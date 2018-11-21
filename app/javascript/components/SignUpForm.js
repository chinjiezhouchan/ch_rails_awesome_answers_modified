import React, { Component } from "react";
import { Button, Form, FormGroup, Label, Input, FormText } from 'reactstrap';

// This is the entry component so there's a good chance we'll use states. 
class SignUpForm extends Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(event) {
    event.preventDefault();
    
    console.log("Submission business")

    const { currentTarget } = event;
    const formData = new FormData(currentTarget);

    // To display all the contents of the FormData object, you must always convert it to an array first.
    console.log(Array.from(formData.entries()));

    fetch(currentTarget.action, {
      method: "POST",
      credentials: "same-origin",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        authenticity_token: formData.get("authenticity_token"),
        first_name: formData.get("user[first_name]"),
        last_name: formData.get("user[last_name]"),
        email: formData.get("user[email]"),
        password: formData.get("user[password]"),
        password_confirmation: formData.get("user[password_confirmation]")
      })
    })
      .then(res => res.json())
      .then(console.log);
  }
  
  render() {
    const { authenticity_token } = this.props;
    return( 
      <Form action="/users" method="POST" onSubmit={this.handleSubmit}>
        <Input
          type="hidden"
          name="authenticity_token"
          value={authenticity_token}
        />

        <FormGroup>
          <Label>First Name</Label>
          <Input type="text" name="user[first_name]" />
        </FormGroup>

        <FormGroup>
          <Label>Last Name</Label>
          <Input type="text" name="user[last_name]" />
        </FormGroup>

        <FormGroup>
          <Label>Email</Label>
          <Input type="email" name="user[email]" />
        </FormGroup>

        <FormGroup>
          <Label>Password</Label>
          <Input type="password" name="user[password]" />
        </FormGroup>

        <FormGroup>
          <Label>Password Confirmation</Label>
          <Input type="password" name="user[password_confirmation]" />
        </FormGroup>

        <Input type="submit" value="Sign Up" />
      </Form>
    )
  }
}

export default SignUpForm;