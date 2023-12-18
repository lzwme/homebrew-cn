cask "kubecontext" do
  version "2.0.1"
  sha256 "9b815995123dcf8a6e90c65600db68fdb38d1e9e362695922b2ec2aad7d74fc2"

  url "https:github.comturkenhKubeContextreleasesdownloadv#{version}KubeContext.zip"
  name "KubeContext"
  desc "Menu bar app for managing Kubernetes contexts"
  homepage "https:github.comturkenhKubeContext"

  depends_on macos: ">= :big_sur"

  app "KubeContext.app"

  zap trash: [
    "~LibraryApplication Scriptscom.ht.kubecontext",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.ht.kubecontext.sfl*",
    "~LibraryContainerscom.ht.kubecontext",
  ]
end