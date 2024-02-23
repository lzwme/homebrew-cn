class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.3.40.tar.gz"
  sha256 "5d7638b43ad8957b31183328bac86b6dee80a93f61a7cbe30fecd2d3d442aa2c"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6faaf2b1c484f3b8a06966ad5a66e559acef185c01d00b079d204e574cc40163"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab6466e7458b26c9ad2a35d870292974929cf79cd10fbe928ff92e2d215bfd5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f53786965bf222be042ef1c096f935c946837b53cc4dc5222f9d139e05fc580b"
    sha256 cellar: :any_skip_relocation, sonoma:         "29fc488575a328487db8664dca46abd62919acea1462b9facf413880622ea2b3"
    sha256 cellar: :any_skip_relocation, ventura:        "7a71738f294da75372ec583fd957d4840a4f02068145a1d5562f4b2c16da6be3"
    sha256 cellar: :any_skip_relocation, monterey:       "93f0032d64fbd0ea8257e81b7e584b8f24d78f7aa13b554b4ddf160e25ec7ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25b4333c4568b7ab36d5fbe14e501ab5e8b5c77493053f08408860a6538764da"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags: ldflags), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end