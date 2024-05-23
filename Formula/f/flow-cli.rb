class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv1.19.1.tar.gz"
  sha256 "139ab290dfbc053b63303f4f3012e64f011ce5140597740a247d804868e4934c"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "073ebd2bc703a6e92b7c366e75af72d8dfe0fe300daa1d98473c86cf2fb10a6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f3936dad3ada6752a98a7ac940a4b665b24674991d7337d253f42457d16c6c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "defc5c978834c667ff6cde4b7b644f64ca09b606a4096d43eaae4391042a75e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d442cb84f2b91aa7996ff2dcaf4d9f370ec70fbe7a5bce67c4b01a5ca12ed2a"
    sha256 cellar: :any_skip_relocation, ventura:        "c78468d202cec3887a06eb813cd3fea7e36efde5f9ec9669eb0aca776ec2a5d9"
    sha256 cellar: :any_skip_relocation, monterey:       "e9e560aa5933858c495df881910f878475c9ee2ef3f8b909209104d309c9af1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28b8d36e0ff299cfe8d08389cea2557c7a282170bee2b07804f117c1930deb93"
  end

  depends_on "go" => :build

  def install
    system "make", "cmdflowflow", "VERSION=v#{version}"
    bin.install "cmdflowflow"

    generate_completions_from_executable(bin"flow", "completion", base_name: "flow")
  end

  test do
    (testpath"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}flow", "cadence", "hello.cdc"
  end
end