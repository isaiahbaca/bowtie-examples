/** @jsx React.DOM */

var App = React.createClass({displayName: "App",
  render: function(){
    return (
      React.createElement("div", null, 
        React.createElement("header", null, 
          React.createElement("h1", null, "Beer Ratings - BowTie.io Demo")
        ), 

        React.createElement(ReactRouter.RouteHandler, null)
      )
    );
  }
});

var Breweries = React.createClass({displayName: "Breweries",
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
      React.createElement("div", {className: "breweries"}, 
        React.createElement(ReactRouter.Link, {to: "add-brewery"}, "New Brewery"), 

        React.createElement("table", null, 
          React.createElement("tbody", null, 
            this.state.breweries.map(function(brewery){
              return (
                React.createElement("tr", {key: brewery.id}, 
                  React.createElement("td", null, React.createElement(ReactRouter.Link, {to: "brewery", params: {breweryId: brewery.id}}, brewery.name)), 
                  React.createElement("td", null, brewery.city), 
                  React.createElement("td", null, brewery.state), 
                  React.createElement("td", null, brewery.country)
                )
              );
            })
          )
        )
      )
    );
  }
});

var AddBrewery = React.createClass({displayName: "AddBrewery",
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
      React.createElement("div", {className: "add-brewery"}, 
        React.createElement("h1", null, "New Brewery"), 

        React.createElement("form", null, 
          React.createElement("input", {type: "text", placeholder: "Brewery Name", value: this.state.name, onChange: this.handleNameChange}), 
          React.createElement("input", {type: "text", placeholder: "City", value: this.state.city, onChange: this.handleCityChange}), 
          React.createElement("input", {type: "text", placeholder: "State", value: this.state.state, onChange: this.handleStateChange}), 
          React.createElement("input", {type: "text", placeholder: "Country", value: this.state.country, onChange: this.handleCountryChange}), 

          React.createElement("button", {onClick: this.handleSubmission}, "Create")
        )
      )
    );
  }
});

var Brewery = React.createClass({displayName: "Brewery",
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
      React.createElement("div", {className: "brewery"}, 
        React.createElement(ReactRouter.Link, {to: "/"}, 
          "Brewery Index"
        ), 

        React.createElement(ReactRouter.Link, {to: "add-beer", params: {breweryId: this.state.breweryId}}, 
          "New Beer"
        ), 

        React.createElement(ReactRouter.RouteHandler, null), 

        React.createElement("h1", null, this.state.brewery.name), 
        React.createElement("h2", null, this.state.brewery.city, ",", 
              this.state.brewery.state, 
              this.state.brewery.country), 

        React.createElement("table", null, 
          React.createElement("tbody", null, 
            this.state.beers.map(function(beer){
              return (
                React.createElement("tr", null, 
                  React.createElement("td", null, 
                    React.createElement(ReactRouter.Link, {to: "beer", params: {breweryId: this.state.breweryId, beerId: beer.id}}, 
                      beer.name)
                  ), 
                  React.createElement("td", null, beer.description)
                )
              );
            }.bind(this))
          )
        )
      )
    );
  }
});

var AddBeer = React.createClass({displayName: "AddBeer",
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
      React.createElement("div", {className: "add-beer"}, 
        React.createElement("h1", null, "New Beer"), 

        React.createElement("form", null, 
          React.createElement("input", {type: "text", placeholder: "Beer Name", value: this.state.name, onChange: this.handleNameChange}), 
          React.createElement("input", {type: "text", placeholder: "Description", value: this.state.description, onChange: this.handleDescriptionChange}), 

          React.createElement("button", {onClick: this.handleSubmission}, "Create")
        )
      )
    );
  }
});

var Beer = React.createClass({displayName: "Beer",
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
      React.createElement("div", {className: "beer"}, 
        React.createElement("h1", null, this.state.beer.name), 
        React.createElement("p", null, this.state.beer.description), 

        React.createElement("div", {className: "brewery"}, 
          React.createElement("h3", null, React.createElement(ReactRouter.Link, {to: "brewery", 
            params: {breweryId: this.state.breweryId}}, 
            this.state.brewery.name)), 

          React.createElement("h4", null, this.state.brewery.city, ",", 
                this.state.brewery.state, 
                this.state.brewery.country)
        ), 

        React.createElement("div", {className: "ratings"}, 
          this.state.ratings.map(function(rating){
            return (
              React.createElement("div", {className: "rating"}, 
                React.createElement("p", {className: "info"}, rating.rating, " / 10 - ", rating.created_at, ":"), 
                React.createElement("p", {className: "comment"}, rating.comment)
              )
            );
          })
        ), 

        React.createElement(AddRating, {beerId: this.state.beerId, 
          breweryId: this.state.breweryId, 
          onAddRating: this.handleAddRating})
      )
    );
  }
});

var AddRating = React.createClass({displayName: "AddRating",
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
      React.createElement("div", {className: "add-beer"}, 
        React.createElement("h1", null, "Rate It"), 

        React.createElement("form", null, 
          React.createElement("input", {type: "text", placeholder: "Comment", 
            value: this.state.comment, onChange: this.handleCommentChange}), 

          React.createElement("select", {value: this.state.rating}, 
            [0,1,2,3,4,5,6,7,8,9,10].map(function(v){
              return (React.createElement("option", {value: v}, v));
            })
          ), 

          React.createElement("button", {onClick: this.handleSubmission}, "Create")
        )
      )
    );
  }
});


var routes = (
  React.createElement(ReactRouter.Route, {name: "app", path: "/", handler: App}, 
    React.createElement(ReactRouter.Route, {name: "add-brewery", path: "breweries/new", handler: AddBrewery}), 
    React.createElement(ReactRouter.Route, {name: "brewery", path: "breweries/:breweryId", handler: Brewery}), 
    React.createElement(ReactRouter.Route, {name: "add-beer", path: "breweries/:breweryId/beers/new", handler: AddBeer}), 
    React.createElement(ReactRouter.Route, {name: "beer", path: "breweries/:breweryId/beers/:beerId", handler: Beer}), 
    React.createElement(ReactRouter.DefaultRoute, {handler: Breweries})
  )
);

ReactRouter.run(routes, function(Handler){
  React.render(React.createElement(Handler, null), $(".page-content .wrapper")[0]);
});
