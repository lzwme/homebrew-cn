cask "openshift-client" do
  arch arm: "-arm64"

  version "4.21.4"
  sha256 arm:   "d566aad59a1bccd21eb00949bad6c8f72a4c3d8a01939414727198b94e4c2b56",
         intel: "02c1f5e6ada56aaacfda95023e508761b742fb0509e6c76c9e801aeb5ec48f97"

  url "https://mirror.openshift.com/pub/openshift-v#{version.major}/clients/ocp/#{version}/openshift-client-mac#{arch}.tar.gz"
  name "Openshift Client"
  desc "Red Hat OpenShift Container Platform command-line client"
  homepage "https://www.openshift.com/"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v#{version.major}/clients/ocp/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  binary "oc"

  zap trash: "~/.kube/config"
end