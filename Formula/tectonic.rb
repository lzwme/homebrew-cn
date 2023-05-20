class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://ghproxy.com/https://github.com/tectonic-typesetting/tectonic/archive/tectonic@0.13.0.tar.gz"
  sha256 "fe49a46419ac2ae6713cd91c68bf817e4026857b5202bedec9b18a8df427773e"
  license "MIT"
  head "https://github.com/tectonic-typesetting/tectonic.git", branch: "master"

  # As of writing, only the tags starting with `tectonic@` are release versions.
  # NOTE: The `GithubLatest` strategy cannot be used here because the "latest"
  # release on GitHub sometimes points to a tag that isn't a release version.
  livecheck do
    url :stable
    regex(/^tectonic@v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "57e0d69826991a7e0ea0c42056690ac0efa3e17ef4ebd888578ff0a64882e34d"
    sha256 cellar: :any,                 arm64_monterey: "f337f73d3c3485f0f82f8161c786cedc87ad2d1f5a7409c94781e6fbda053291"
    sha256 cellar: :any,                 arm64_big_sur:  "a3806ad4173553c1711c3726668fade564df9e6464d060b39aaf81c7fa86ae57"
    sha256 cellar: :any,                 ventura:        "da0ca45907a905c89121e38a90c0f2253500c9be11f73d0d8af1bc53935ef6a9"
    sha256 cellar: :any,                 monterey:       "480670aee465c78a5a4706593f957965c6c807aab61bae11898b597a1590adac"
    sha256 cellar: :any,                 big_sur:        "c1c3d4d16c9a4a7f29d66f3edf81af31b4da703bf1adfd8652af0befe5c181b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aacc8ff8b9c2cfd5bfb6ec1f6a9f1b6cdb2205b04fb2b0b2dd699668a97501c3"
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