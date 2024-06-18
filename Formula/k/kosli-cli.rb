class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.8.tar.gz"
  sha256 "4028506fa664d9a526375e2eca08573ee29c4ab2145771b89edac10b238ec83d"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52ef9c946f6c0797fa17a401faf2bc2e05c40f7716f348672201d51d3daf859d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "694162d4ad6495bc68c2076e511854430399aa5e59edeec0babc50c395b8b9b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "179c32038728dc9b97cd85173cae864c3781ec54881e9ee4a5940ce95692dacb"
    sha256 cellar: :any_skip_relocation, sonoma:         "129746e6a11feac4ba8ab07f56e36f17aac9ee82a0ddd303aa9dba4a9a013a6a"
    sha256 cellar: :any_skip_relocation, ventura:        "406fd19063ead38c8b91f211e9edca9c62bb1ca427cf21e10130e623f5d45f3c"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e44c9682c945b07c219eeab423ec1f436504df8d65519975e82a301ee7da95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e785efab0cac48c01b78c8120b8abd83002b744fc21ecceb36af3ad98e80d725"
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