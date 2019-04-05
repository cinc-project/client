class Chef
  class Dist
    # When referencing a product directly, like Chef (Now Chef Infra)
    PRODUCT = "Cinc Infra"

    # The client's alias (chef-client)
    CLIENT = "cinc-client"

    # the server tool's name (knife)
    KNIFE = "knife"

    # Name used for certain directories. Merge with chef_executable?
    GENERIC = "Cinc"

    # The chef executable, as in `chef gem install` or `chef generate cookbook`
    EXEC = "cinc"

    # product website address
    WEBSITE = "https://git.iabis.net/cinc"
  end
end