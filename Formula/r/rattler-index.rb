class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.26.3.tar.gz"
  sha256 "2990eacf73ff15cd83782322811a9e892f6204800bffb2022ce814b122f9fffb"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db03928c3eceb56c9869d747aeb7e56764dbbfeeb012d7a80cd97a47f1d69539"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54118b7f17396b33db6f49fb8f3760dae12ec17604df523ec01f6e18c81c7816"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37c2131e05e66af8c0e9c192c7d00450e346405eecb888c94da7b6e4abaf60f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4428b7768e92ab5f83187ba5b91d5c54f8a2d6a671006ea38d2b8b9337e809c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12cd70eac3c009f85a9a6a30e564c22797ed24036f5f4a0849fd805301c57804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc4f9f6f65a0916df451ea27f8689e8cba89bd09bf8d0d634dc6eb5728e27557"
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