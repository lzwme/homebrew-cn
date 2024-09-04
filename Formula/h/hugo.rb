class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.134.0.tar.gz"
  sha256 "6be360951c3c5f80f00e8302314d16781057aff0f9f8b502d356dc35ee4aa1d1"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b2487e6ce6e1d82b16168d6fe22b9c752baac610f85004180ea646d29fa0f47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a60e2ce0b1c3d96060a238c66b24e9fcdc33938f51c44ef26653ba70d8298ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d96ba6fc80b6ebdf14516159b5357dca9dce3211a3de87d744aef85094b1c83"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2e01713daebfdab3c763335de886b8535a25ffd268ff8182e1904a8cf07ae83"
    sha256 cellar: :any_skip_relocation, ventura:        "a2cdfd2d98a65cc6fc1d84d9ac16c5d01e3c4a78728e8e6b402c402afc625eac"
    sha256 cellar: :any_skip_relocation, monterey:       "ba1081141b3375915a4fb906a280a984ec082fa1cd0e09adba68d8e1a3b92437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5f6e5b4784c10768f11127e33c14a62bdb587910d8ea8b4b88934acebeffd1a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended"

    generate_completions_from_executable(bin"hugo", "completion")
    system bin"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath"hops-yeast-malt-water"
    system bin"hugo", "new", "site", site
    assert_predicate site"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin"hugo version")
  end
end