cask "kube-cluster" do
  version "0.5.3"
  sha256 "a19384f36a215af485f6ca2761091feaf7b6e3825a4f19845bd627c82c4d4083"

  url "https:github.comTheNewNormalkube-cluster-osxreleasesdownloadv#{version}Kube-Cluster_v#{version}.dmg"
  name "Kube-Cluster"
  homepage "https:github.comTheNewNormalkube-cluster-osx"

  app "Kube-Cluster.app"

  zap trash: "~kube-cluster"

  caveats do
    discontinued
  end
end