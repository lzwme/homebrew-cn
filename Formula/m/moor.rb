class Moor < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moor"
  url "https://ghfast.top/https://github.com/walles/moor/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "1e9b26de52fcc9434e54c2ea4c5ee9f0554d52e2fb5795a13c0b8b943a950651"
  license "BSD-2-Clause"
  head "https://github.com/walles/moor.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9a8e5529c296ecaae654afaf001a4f923bd537be4c5315656e823260dd5ce72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9a8e5529c296ecaae654afaf001a4f923bd537be4c5315656e823260dd5ce72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9a8e5529c296ecaae654afaf001a4f923bd537be4c5315656e823260dd5ce72"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d13d1f49eb123897f023dce44e8e9a870184efc09c5c2f6b25479c6c53af513"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f42300b72c765e2eedd21cd5989412daa0d4d654db8b5fdb138a57e3a9cc73c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36d67ca3c9e6a72bf0a43831b9fafe724e01f9628aebafef5f8ae9d67bdea157"
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