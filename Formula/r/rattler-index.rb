class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.28.2.tar.gz"
  sha256 "9885bf03afd3fd43f70051d7da90e90dda21f1cf7998766a239c4dbad0b9a40c"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "603ab28e8e16df27806ab867bc231ea5a5503f7db7ec1d01fd90ed6c78bdeb89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37e1037905389b788b1f77a75ea76dc708136f7634d24c2dcb9ce245e47cfa7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "816763c1cf82c1ef12eb58bcd1e118b70a110c363e56e3696e13cafe9b766890"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f7659febb01437ef7d2dc6decdda1a8641e858672e5a5e82bb3d3edcf2aa482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cea10516bcffc891a3b8611dce35b9473fc1246c5499383e5ff1e84d22a0be9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6b7094de55d5ff36bafcdebbf9692678037b3caf660459c71effe402d4da505"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    features = %w[native-tls rattler_config s3]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/rattler_index", features:)
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end