import {Badge, Card, DisplayText, Modal, Stack, TextContainer} from '@shopify/polaris';
import React from 'react';
import {gql, useQuery} from "@apollo/client";

export default function CollectionDetail(props) {
  const {close, collectionId, collectionName} = props

  const {loading, error, data} = useQuery(gql`query { orders(collectionId: "${collectionId}") }`);

  if (loading) {
    return (
      <Modal
        open={true}
        onClose={close}
        title={collectionName}
        loading={true}
      >
      </Modal>
    );
  } else if (error) {
    console.log(error)
    return (
      <div>エラーが発生しました</div>
    );
  } else {
    const item = JSON.parse(data.orders)

    return (
      <Modal
        open={true}
        onClose={close}
        title={collectionName}
        loading={false}
      >
        <Modal.Section>
          <TextContainer>
            <Card>
              <Card.Section title={'売掛金'}>
                <Stack alignment="center">
                  <Badge>日次</Badge>
                  <DisplayText size="small">{item.accountsReceivable.daily.toLocaleString()}円</DisplayText>
                </Stack>
                <Stack>
                  <Badge>月次</Badge>
                  <DisplayText size="small">{item.accountsReceivable.monthly.toLocaleString()}円</DisplayText>
                </Stack>
              </Card.Section>
              <Card.Section title={'売上金'}>
                <Stack alignment="center">
                  <Badge>日次</Badge>
                  <DisplayText size="small">{item.proceeds.daily.toLocaleString()}円</DisplayText>
                </Stack>
                <Stack>
                  <Badge>月次</Badge>
                  <DisplayText size="small">{item.proceeds.monthly.toLocaleString()}円</DisplayText>
                </Stack>
              </Card.Section>
            </Card>
          </TextContainer>
        </Modal.Section>
      </Modal>
    )
  }
}
