class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://velero.io/"
  url "https://ghproxy.com/https://github.com/vmware-tanzu/velero/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "6190a8ea4c4abe71be5cc8f4de645ba1dc17554b8e368b8f30f8fbada43f54f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d3c5dac73278a82c47405497b8b58372b59893e16fe556add5fb3bdee48a77e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fc69d2c3663e121a12f97c1a4abe8fee93052d060f08a25121969072425f596"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfe34bbc41f2b1ef95989da2c8eee55c8e53f13d9234d8daf5f169b627208660"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ce1d7280b70caa16671333ce7c110a5595b4e94662b4415e5b32e41622c1046"
    sha256 cellar: :any_skip_relocation, ventura:        "f6f04c504e5f6213f68e33c21f0707276db1de11eb873ff6c6f6fdb8d0233508"
    sha256 cellar: :any_skip_relocation, monterey:       "f5ea8861dbf45f6dac6faab3820850e7b77941d11456d16fa05467002f116383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a059f1eaf2599c4560ac5e7ebc9e9959da1000e321f1511b6a7505186899bb9b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-installsuffix", "static", "./cmd/velero"

    generate_completions_from_executable(bin/"velero", "completion")
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end