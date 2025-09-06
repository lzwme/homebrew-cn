class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "e9233a946218a1e36e7798b657d6bd3a8ef5b130b5103688f35943127487d28c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffc2d5335d0b477c0d019bebdd41036e757ec70006857438dd553fc88ec7d101"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "608004a660494240ab66e2b36bb1c315349103d5a85f6535fc562575c68fd467"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40db8b58c28480eb93a653e3c3158693b8862782d1b389da6b9b230ffd9d8183"
    sha256 cellar: :any_skip_relocation, sonoma:        "f303599512528a636ae89f498be4f67f4ac2e800a0c7767cac7d596cd721a122"
    sha256 cellar: :any_skip_relocation, ventura:       "cf25a6a3a115f1788e48d15a778ddb3f1843eef2af3bd95b6491067586de1ae5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e7994cd495f0f583a6a34fa623328941141aaf4ed55c84cb7d94c3806c9c350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a0d2b599123382e5e983d838ac7419fdb4a2b2c7d63fa89f5b415dd53df52a2"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end