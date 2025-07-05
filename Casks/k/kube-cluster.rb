cask "kube-cluster" do
  version "0.5.3"
  sha256 "a19384f36a215af485f6ca2761091feaf7b6e3825a4f19845bd627c82c4d4083"

  url "https://ghfast.top/https://github.com/TheNewNormal/kube-cluster-osx/releases/download/v#{version}/Kube-Cluster_v#{version}.dmg"
  name "Kube-Cluster"
  homepage "https://github.com/TheNewNormal/kube-cluster-osx"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Kube-Cluster.app"

  zap trash: "~/kube-cluster"
end