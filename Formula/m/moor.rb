class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "8530e171c281aa49d050b9b8ecf81ddb48b5de90d9dca54b2f427765085db46f"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aabdfa65de4dba41e0669bf8a4de4752c165c4e06bb83fcfd2c9f52df3cc0ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aabdfa65de4dba41e0669bf8a4de4752c165c4e06bb83fcfd2c9f52df3cc0ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5aabdfa65de4dba41e0669bf8a4de4752c165c4e06bb83fcfd2c9f52df3cc0ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae0d007a56e770eb93620f0dee54475033ccd7c4f09dd823323958b52fede014"
    sha256 cellar: :any_skip_relocation, ventura:       "ae0d007a56e770eb93620f0dee54475033ccd7c4f09dd823323958b52fede014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44f915b8ac3c8017a11b6b237ecd8fec0d4019c8f756c6ead681b4364ea63a64"
  end

  depends_on "go" => :build

  conflicts_with "moarvm", "rakudo-star", because: "both install `moar` binaries"

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/moor"

    # Hint for moar users to start typing "moor" instead
    bin.install "scripts/moar"

    man1.install "moor.1"
  end

  test do
    # Test piping text through moor
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moor test.txt").strip
  end
end