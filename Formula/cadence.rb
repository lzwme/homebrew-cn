class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/v0.39.14.tar.gz"
  sha256 "e2e860f04774895275a4b8184317a7b88f868edd908f90f9ec868cd9ab8fdda2"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4324be2c9e797779dcb1bd747399ddecf98bac94d553204eabf0b966310645bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4324be2c9e797779dcb1bd747399ddecf98bac94d553204eabf0b966310645bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4324be2c9e797779dcb1bd747399ddecf98bac94d553204eabf0b966310645bc"
    sha256 cellar: :any_skip_relocation, ventura:        "c77869d261eb7a3e88d110e49738618e227381f8a533625acdd5622ecd77add0"
    sha256 cellar: :any_skip_relocation, monterey:       "c77869d261eb7a3e88d110e49738618e227381f8a533625acdd5622ecd77add0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c77869d261eb7a3e88d110e49738618e227381f8a533625acdd5622ecd77add0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2876a64376c58958fd9b0c317c9991fb560756b5f6e6dcf5fc490357ad41869"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end