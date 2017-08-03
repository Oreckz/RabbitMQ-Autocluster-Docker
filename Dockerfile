FROM rabbitmq:management
ADD plugins/autocluster-0.8.0.ez \
/usr/lib/rabbitmq/lib/rabbitmq_server-$RABBITMQ_VERSION/plugins/
ADD plugins/rabbitmq_aws-0.8.0.ez \
/usr/lib/rabbitmq/lib/rabbitmq_server-$RABBITMQ_VERSION/plugins/
RUN rabbitmq-plugins enable --offline autocluster rabbitmq_federation rabbitmq_federation_management rabbitmq_management_visualiser
