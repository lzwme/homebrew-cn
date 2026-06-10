class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.30.4.tar.gz"
  sha256 "1d61cbdc7da215150c01e34f07c0dd7e9b557b25c922d1215767eef519f09af8"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c32fe061bc6a643c49d269e58037f3f3fcd33db1ac42dbbf71f063bc153aa31c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab3aad12dabc6f261506dad0f788080cea42feb109d82670515e21c78b063f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac4b1668a1a6f0b8d1f044ce1f8889cfc6e50404fae61769d90647665aa61f13"
    sha256 cellar: :any_skip_relocation, sonoma:        "45771ed9164c780b20d025e694444eea9d34c9357ff86e1b0bb65b2e3e2908f3"
    sha256 cellar: :any,                 arm64_linux:   "7be370e9e3fae2633fa4ccd036fd26204850710ee023c17fb63fe4ef3f71362d"
    sha256 cellar: :any,                 x86_64_linux:  "82ce14bbe4e640dfc7b87d7666b7a42461d2da077d780c137971bd8dfae03a71"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    features = %w[native-tls s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end