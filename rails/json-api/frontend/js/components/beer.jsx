/** @jsx React.DOM */

var App = React.createClass({
  render: function(){
    return (
      <div>
        <header>
          <h1>Beer Ratings - BowTie.io Demo</h1>
        </header>

        <ReactRouter.RouteHandler />
      </div>
    );
  }
});

var Breweries = React.createClass({
  getInitialState: function(){
    return {
      breweries: []
    }
  },

  componentDidMount: function(){
    $.get("/breweries.json", function(response){
      this.setState({ breweries: response.data });
    }.bind(this));
  },

  componentWillReceiveProps: function () {
    console.log("Breweries#componentWillReceiveProps");
    this.componentDidMount();
  },

  render: function(){
    return (
      <div className="breweries">
        <ReactRouter.Link to="add-brewery">New Brewery</ReactRouter.Link>

        <table>
          <tbody>
            {this.state.breweries.map(function(brewery){
              return (
                <tr key={brewery.id}>
                  <td><ReactRouter.Link to="brewery" params={{breweryId: brewery.id}}>{brewery.name}</ReactRouter.Link></td>
                  <td>{brewery.city}</td>
                  <td>{brewery.state}</td>
                  <td>{brewery.country}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    );
  }
});

var AddBrewery = React.createClass({
  mixins: [ReactRouter.Navigation],

  getInitialState: function(){
    return {
      name: null,
      city: null,
      state: null,
      country: null
    }
  },

  handleNameChange: function(event){
    this.setState({ name: event.target.value });
  },

  handleCityChange: function(event){
    this.setState({ city: event.target.value });
  },

  handleStateChange: function(event){
    this.setState({ state: event.target.value });
  },

  handleCountryChange: function(event){
    this.setState({ country: event.target.value });
  },

  handleSubmission: function(){
    $.post("/breweries.json", {
      brewery: {
        name: this.state.name,
        city: this.state.city,
        state: this.state.state,
        country: this.state.country
      }
    }).done(function(response){
      this.transitionTo("brewery", { breweryId: response.data.id });
    }.bind(this)).fail(function(){
      alert("Sorry, an error occurred!");
    })
  },

  render: function(){
    return (
      <div className="add-brewery">
        <h1>New Brewery</h1>

        <form>
          <input type="text" placeholder="Brewery Name" value={this.state.name} onChange={this.handleNameChange} />
          <input type="text" placeholder="City" value={this.state.city} onChange={this.handleCityChange} />
          <input type="text" placeholder="State" value={this.state.state} onChange={this.handleStateChange} />
          <input type="text" placeholder="Country" value={this.state.country} onChange={this.handleCountryChange } />

          <button onClick={this.handleSubmission}>Create</button>
        </form>
      </div>
    );
  }
});

var Brewery = React.createClass({
  mixins: [ReactRouter.State],

  getInitialState: function(){
    return {
      breweryId: this.getParams().breweryId,
      brewery: {},
      beers: []
    }
  },

  fetchData: function(){
    $.get("/breweries/" + this.state.breweryId + ".json", function(response){
      this.setState({ brewery: response.data });
    }.bind(this));

    $.get("/breweries/" + this.state.breweryId + "/beers.json", function(response){
      this.setState({ beers: response.data });
    }.bind(this));
  },

  componentDidMount: function(){
    this.fetchData();
  },

  componentWillReceiveProps: function () {
    this.fetchData();
  },

  render: function(){
    return (
      <div className="brewery">
        <ReactRouter.Link to="/">
          Brewery Index
        </ReactRouter.Link>

        <ReactRouter.Link to="add-beer" params={{breweryId: this.state.breweryId}}>
          New Beer
        </ReactRouter.Link>

        <ReactRouter.RouteHandler />

        <h1>{this.state.brewery.name}</h1>
        <h2>{this.state.brewery.city},
              {this.state.brewery.state}
              {this.state.brewery.country}</h2>

        <table>
          <tbody>
            {this.state.beers.map(function(beer){
              return (
                <tr>
                  <td>
                    <ReactRouter.Link to="beer" params={{breweryId: this.state.breweryId, beerId: beer.id}}>
                      {beer.name}</ReactRouter.Link>
                  </td>
                  <td>{beer.description}</td>
                </tr>
              );
            }.bind(this))}
          </tbody>
        </table>
      </div>
    );
  }
});

var AddBeer = React.createClass({
  mixins: [ReactRouter.State, ReactRouter.Navigation],

  getInitialState: function(){
    return {
      breweryId: this.getParams().breweryId,
      name: null,
      description: null
    }
  },

  handleNameChange: function(event){
    this.setState({ name: event.target.value });
  },

  handleDescriptionChange: function(event){
    this.setState({ description: event.target.value });
  },

  handleSubmission: function(){
    $.post("/breweries/" + this.state.breweryId + "/beers.json", {
      beer: {
        name: this.state.name,
        description: this.state.description
      }
    }).done(function(response){
      this.transitionTo("beer", {
        breweryId: response.data.id,
        beerId: response.data.id
      });
    }.bind(this)).fail(function(){
      alert("Sorry, an error occurred!");
    })
  },

  render: function(){
    return (
      <div className="add-beer">
        <h1>New Beer</h1>

        <form>
          <input type="text" placeholder="Beer Name" value={this.state.name} onChange={this.handleNameChange} />
          <input type="text" placeholder="Description" value={this.state.description} onChange={this.handleDescriptionChange} />

          <button onClick={this.handleSubmission}>Create</button>
        </form>
      </div>
    );
  }
});

var Beer = React.createClass({
  mixins: [ReactRouter.State],

  getInitialState: function(){
    return {
      breweryId: this.getParams().breweryId,
      beerId: this.getParams().beerId,
      brewery: {},
      beer: {},
      ratings: []
    }
  },

  componentDidMount: function(){
    // TODO: our API should probably return this information better combined for our response,
    // but we're keeping this as simple as possible.

    $.get("/breweries/" + this.state.breweryId + ".json", function(response){
      this.setState({ brewery: response.data });
    }.bind(this));

    $.get("/breweries/" + this.state.breweryId + "/beers/" + this.state.beerId + ".json", function(response){
      this.setState({ beer: response.data });
    }.bind(this));

    $.get("/breweries/" + this.state.breweryId + "/beers/" + this.state.beerId + "/ratings.json", function(response){
      this.setState({ ratings: response.data });
    }.bind(this));
  },

  componentWillReceiveProps: function () {
    this.componentDidMount();
  },

  handleAddRating: function(rating){
    var ratings = this.state.ratings.slice(0);
    ratings.push(rating);
    this.setState({ ratings: ratings });
  },

  render: function(){
    return (
      <div className="beer">
        <h1>{this.state.beer.name}</h1>
        <p>{this.state.beer.description}</p>

        <div className="brewery">
          <h3><ReactRouter.Link to="brewery"
            params={{breweryId: this.state.breweryId}}>
            {this.state.brewery.name}</ReactRouter.Link></h3>

          <h4>{this.state.brewery.city},
                {this.state.brewery.state}
                {this.state.brewery.country}</h4>
        </div>

        <div className="ratings">
          {this.state.ratings.map(function(rating){
            return (
              <div className="rating">
                <p className="info">{rating.rating} / 10 - {rating.created_at}:</p>
                <p className="comment">{rating.comment}</p>
              </div>
            );
          })}
        </div>

        <AddRating beerId={this.state.beerId}
          breweryId={this.state.breweryId}
          onAddRating={this.handleAddRating}/>
      </div>
    );
  }
});

var AddRating = React.createClass({
  getInitialState: function(){
    return {
      beerId: this.props.beerId,
      breweryId: this.props.breweryId,
      rating: null,
      comment: null
    }
  },

  handleRatingChange: function(event){
    this.setState({ rating: event.target.value });
  },

  handleCommentChange: function(event){
    this.setState({ comment: event.target.value });
  },

  handleSubmission: function(){
    var rating = {
      rating: null,
      comment: null
    };

    this.props.onAddRating(rating);

    $.post("/breweries/" + this.state.breweryId + "/beers/" + this.state.beerId + "/ratings.json", {
      rating: rating
    }).done(function(response){
      console.log("Rating saved.");
    }).fail(function(){
      alert("Sorry, an error occurred!");
    });
  },

  render: function(){
    return (
      <div className="add-beer">
        <h1>Rate It</h1>

        <form>
          <input type="text" placeholder="Comment"
            value={this.state.comment} onChange={this.handleCommentChange} />

          <select value={this.state.rating}>
            {[0,1,2,3,4,5,6,7,8,9,10].map(function(v){
              return (<option value={v}>{v}</option>);
            })}
          </select>

          <button onClick={this.handleSubmission}>Create</button>
        </form>
      </div>
    );
  }
});


var routes = (
  <ReactRouter.Route name="app" path="/" handler={App}>
    <ReactRouter.Route name="add-brewery" path="breweries/new" handler={AddBrewery}/>
    <ReactRouter.Route name="brewery" path="breweries/:breweryId" handler={Brewery} />
    <ReactRouter.Route name="add-beer" path="breweries/:breweryId/beers/new" handler={AddBeer}/>
    <ReactRouter.Route name="beer" path="breweries/:breweryId/beers/:beerId" handler={Beer}/>
    <ReactRouter.DefaultRoute handler={Breweries}/>
  </ReactRouter.Route>
);

ReactRouter.run(routes, function(Handler){
  React.render(<Handler/>, $(".page-content .wrapper")[0]);
});
