class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.26.1.tar.gz"
  sha256 "3ea0f183402d87bfd21f1a3cd8eb077ee2c089f0fe378ea3c51ed561ed312581"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3288d537518ea3d105045d41c919179d55dee54f0426cbe3e08ec3f823842fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ac304eb165d9b2b839f5b0d5c676cc433e1f89256739d6260d275ca0233c1aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05e5999cc551c39e1f5e14a889af4a652dcd3ec0b5ad0bd88cdc0bb1dd4b5533"
    sha256 cellar: :any_skip_relocation, sonoma:        "93b4860b2a7a8749792b9e794e6bfb32c5d7f883eddcdd87b3caadf010b71fd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cc26c0eea21b8a5bbf38c490249e9e0037472046f343ada721542ef81f04ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a5a4b2eeb5d515bcc6257125213edb298da892cbc805eb2097c5f99d2d9b42"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls,rattler_config", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end