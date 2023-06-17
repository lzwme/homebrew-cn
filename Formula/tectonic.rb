class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://ghproxy.com/https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.14.1.tar.gz"
  sha256 "3703a4fc768b3c7be6a4560857b17b2671f19023faee414aa7b6befd24ec9d25"
  license "MIT"
  revision 1
  head "https://github.com/tectonic-typesetting/tectonic.git", branch: "master"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f3f2d11a4ce369f5c6b501b3504edcddc0f821c44bc52e2bb829ff2238d6be3"
    sha256 cellar: :any,                 arm64_monterey: "8363c83668e45340ebaa2924a08c5cddda6dc7578b1f699c1194176bead1bf99"
    sha256 cellar: :any,                 arm64_big_sur:  "95220f51c7530b2bf11a79c156a5aa5e0ba16e8b832d7e1cffff8de84d15d841"
    sha256 cellar: :any,                 ventura:        "861d45e1adf751c77a6d3e5a85e5d86d4286d4cac099edf82c40188bc8a9cced"
    sha256 cellar: :any,                 monterey:       "f8352b2bd8cc27ebeece409a3b9ca8fddd5cccf58ff4b70f5cc1756140c868c0"
    sha256 cellar: :any,                 big_sur:        "942034cafee1729c67a38e9c94b6b2cff546c4c59fa305d2d255c809f9986d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efa398c246fba43bab1b9fcf46a975e43149b9c84674d9049a765b33c3257823"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "openssl@1.1"

  def install
    ENV.cxx11
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version.to_s # needed for CLT-only builds
    ENV.delete("HOMEBREW_SDKROOT") if MacOS.version == :high_sierra

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--features", "external-harfbuzz", *std_cargo_args
  end

  test do
    (testpath/"test.tex").write 'Hello, World!\bye'
    system bin/"tectonic", "-o", testpath, "--format", "plain", testpath/"test.tex"
    assert_predicate testpath/"test.pdf", :exist?, "Failed to create test.pdf"
    assert_match "PDF document", shell_output("file test.pdf")
  end
end