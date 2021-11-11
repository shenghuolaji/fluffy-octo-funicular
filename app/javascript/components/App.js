import {AppProvider, Page} from '@shopify/polaris';
import enTranslations from '@shopify/polaris/locales/en.json';
import React from 'react';
import Collections from "./Collections";
import {ApolloClient, ApolloProvider, HttpLink, InMemoryCache} from "@apollo/client";
import {authenticatedFetch} from "@shopify/app-bridge-utils";

export default function App() {
  const client = new ApolloClient({
    link: new HttpLink({
      credentials: 'same-origin',
      fetch: authenticatedFetch(window.app), // created in shopify_app.js
      uri: '/graphql'
    }),
    cache: new InMemoryCache()
  });

  return (
    <AppProvider i18n={enTranslations}>
      <ApolloProvider client={client}>

        <Page>
          <Collections/>
        </Page>

      </ApolloProvider>
    </AppProvider>
  );
}
