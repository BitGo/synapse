Synapse will no longer serve any media repo admin endpoints when `enable_media_repo` is set to False in the configuration. If a media repo worker is used, the admin APIs relating to the media repo will be served from it instead.