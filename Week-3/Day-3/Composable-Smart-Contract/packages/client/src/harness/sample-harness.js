import "../components/page-panel.js";
import "../components/page-body.js";
import "../components/action-card.js";
import "../components/account-widget.js";
import "../components/text-widget.js";
import "../components/number-widget.js";
import "../components/switch-widget.js";

import DappLib from "@decentology/dappstarter-dapplib";
import { LitElement, html, customElement, property } from "lit-element";

@customElement('sample-harness')
export default class SampleHarness extends LitElement {
  @property()
  title;
  @property()
  category;
  @property()
  description;

  createRenderRoot() {
    return this;
  }

  constructor(args) {
    super(args);
  }

  render() {
    let content = html`
      <page-body title="${this.title}" category="${this.category}" description="${this.description}">
      
        <!-- Registry >
      
        <action-card title="Registry - Get Auth NFT"
          description="Register a Tenant with the RegistryService to get an AuthNFT" action="receiveAuthNFT" method="post"
          fields="signer">
          <account-widget field="signer" label="Account">
          </account-widget>
        </action-card>
      
        <action-card title="Registry - Has Auth NFT" description="Checks to see if an account has an AuthNFT"
          action="hasAuthNFT" method="get" fields="tenant">
          <account-widget field="tenant" label="Tenant Account">
          </account-widget>
        </action-card>
      
        <action-card title="RegistrySampleContract - Get Tenant"
          description="Get an instance of a Tenant from RegistrySampleContract to have your own data" action="receiveTenant"
          method="post" fields="signer">
          <account-widget field="signer" label="Account">
          </account-widget>
        </action-card>
      
        <!-- Flow Token -->
        <action-card title="Get Balance" description="Get the Flow Token balance of an account" action="getBalance"
          method="get" fields="account">
          <account-widget field="account" label="Account">
          </account-widget>
        </action-card>




        <!-- W3Q3 -->
        <!-- Get User Name -->
        <action-card title="Get Username" description="Get the username from tenant profile" action="getUsername"
          method="get" fields="account">
          <account-widget field="account" label="Account">
          </account-widget>

        </action-card>
        <!-- Set User Name -->
        <action-card title="Set Username" description="Set the username for tenant profile" action="setUsername"
          method="post" fields="signer name">
          <account-widget field="signer" label="Account"></account-widget>
          <text-widget field="name" label="Username" placeholder=""> </text-widget>
        </action-card>
        <!-- W3Q3 -->



      
      </page-body>
      <page-panel id="resultPanel"></page-panel>
    `;

    return content;
  }
}
