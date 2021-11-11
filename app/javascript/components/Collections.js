import {gql, useQuery} from '@apollo/client';
import React, {useState} from 'react';
import enTranslations from '@shopify/polaris/locales/en.json';
import {Card, Loading, Frame, ResourceList, TextStyle} from '@shopify/polaris';
import CollectionDetail from "./CollectionDetail";

export default function Collections() {
  const {loading, error, data} = useQuery(gql`query { collections }`);
  const [showDetail, setShowDetail] = useState();

  if (loading) {
    return (
      <div style={{height: '100px'}}>
        <Frame>
          <Loading/>
        </Frame>
      </div>
    );
  } else if (error) {
    console.log(error)
    return (
      <div>エラーが発生しました</div>
    );
  } else {

    return (
      <>
        <Card title={'コレクション一覧'}>
          <Card.Section>
            <ResourceList
              i18n={enTranslations}
              items={JSON.parse(data.collections)}
              renderItem={(item) => {
                const {id, title} = item;

                return (
                  <>
                    <ResourceList.Item
                      id={id}
                      key={id}
                      accessibilityLabel={`View details for ${title}`}
                      onClick={() => setShowDetail(id)}
                    >
                      <h3>
                        <TextStyle variation="strong">{title}</TextStyle>
                      </h3>
                    </ResourceList.Item>
                    {showDetail === id &&
                    <CollectionDetail collectionId={id} collectionName={title}
                                      close={() => setShowDetail('')}/>}
                  </>
                );
              }}
            />
          </Card.Section>
        </Card>
      </>
    )
  }
}
