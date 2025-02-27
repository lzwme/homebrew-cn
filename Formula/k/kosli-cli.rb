class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.11.9.tar.gz"
  sha256 "b729f229642bbcbdb765825df520de9c79fa778c75662e6080a4b9b52d613f3c"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cf00b928a1cc3c12bdb9f7a4968ca1bce34fedd5fe28c9d42c06d5b8dfdb7ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f66866563a083f676f911cc44d44236c182614533e57f622c017eba92fc9dad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e1c828909c1146a405b51d8e2ca9932a4c4916badf770bf7e367f95ef5a85977"
    sha256 cellar: :any_skip_relocation, sonoma:        "40997604d6f72a07c9dcbc0a852af3e64f71833502353adfcfcbca9ac302b471"
    sha256 cellar: :any_skip_relocation, ventura:       "4f39cc9c1932dfaa3f5baa8a1fdfc0dae28f4fe0f48d17437e347a56a575273f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7145e5ccf335f5681937271bcdeb8e619f8c8b29816a4ee143bc30bb3c943f73"
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

    generate_completions_from_executable(bin"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end