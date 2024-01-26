cask "secretive" do
  on_catalina :or_older do
    version "1.0.3"
    sha256 "d8522c153f20cd03513e6815bdb46be98eae0db2b2a45d30f60b25a6609d1657"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "2.4.1"
    sha256 "00ddf651f1151f1e3888c51e58ce343f6888480db79771b6de7371db21bde4d8"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  url "https:github.commaxgoedjensecretivereleasesdownloadv#{version}Secretive.zip"
  name "Secretive"
  desc "Store SSH keys in the Secure Enclave"
  homepage "https:github.commaxgoedjensecretive"

  depends_on macos: ">= :catalina"

  app "Secretive.app"

  zap trash: [
    "~LibraryApplication Scriptscom.maxgoedjen.Secretive.Host",
    "~LibraryApplication Scriptscom.maxgoedjen.Secretive.SecretAgent",
    "~LibraryContainerscom.maxgoedjen.Secretive.Host",
    "~LibraryContainerscom.maxgoedjen.Secretive.SecretAgent",
  ]
end