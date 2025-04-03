class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https:danielmiessler.compfabric-origin-story"
  url "https:github.comdanielmiesslerfabricarchiverefstagsv1.4.168.tar.gz"
  sha256 "d68edc138b1879a0d500552cd5dc58d00592df8e1adc3be3ab959faeed8c4e57"
  license "MIT"
  head "https:github.comdanielmiesslerfabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84d04dbac1d37222dbc4530ade959f23f0be955d759685a0080988d8a5724c57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84d04dbac1d37222dbc4530ade959f23f0be955d759685a0080988d8a5724c57"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84d04dbac1d37222dbc4530ade959f23f0be955d759685a0080988d8a5724c57"
    sha256 cellar: :any_skip_relocation, sonoma:        "b96c35e4aea431d87894be535dbbc4bea0c40f592117aa4d23adce8b9aab9028"
    sha256 cellar: :any_skip_relocation, ventura:       "b96c35e4aea431d87894be535dbbc4bea0c40f592117aa4d23adce8b9aab9028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "119565c2609ac87bd9da6001cb1133741e0a8e1c2c604761ac0c3e5c60b01195"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fabric-ai --version")

    (testpath".configfabric.env").write("t\n")
    output = shell_output("#{bin}fabric-ai --dry-run < devnull 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end