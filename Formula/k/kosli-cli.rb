class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.11.2.tar.gz"
  sha256 "518aabc29b09af9eaf7760c21fe4c80439a0aca4e8158e2f531c6c83650e49ee"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37954d33a060fa11ead39a78c7ac25afcda811c12271a7a0f970936dfbc9e61a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a44b0157f7b72eca2ed912afa4bb6e6ef272b22b0071921c709d2bf56edb49c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e6a5b31359f0f8257774bc9890655b323ff3ee3b5e43b4151a86daa4cb6c0fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b0b8f6c906db2afab7d9b3d8741b89e864701da256a64e5e2fde90eb3d0198c"
    sha256 cellar: :any_skip_relocation, ventura:       "006b49af3ce169b1c9d0c16055225c37c29ae8488e606e19ec97e21c9b001898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5ffbd90d15937b1c120cac30856b8d7fbbe1ec4d7d641491720973f0564f1c0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end