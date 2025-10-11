class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.26.0.tar.gz"
  sha256 "b33a8238bb45c8de235f74ce76ebd34682f5fe1c9214f5217b93a4699066570e"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e669ba2d3b31e50a151f526f7e6935627abaea02bc17a7bc11ea17f5f9f03f42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "829d1d83b3d153bbec4b7b746a6254f15c9fd913340e16b9b4dab390f401fe53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad2a557605e17cdacddba2606517f7036f031846e1b905d041b65d6a51200948"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0b78257911753a43040ec2c63b41c4fbe0058af0bb6eb391e98ebe0de547f09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "273b8d81c345a6f862eaa714e77260960514e00a1e26ed1500f27aa56a61cc90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96ef4ef0e1a4fa9cba21bab1fd0abe31158b60c5d174ebeb435451838300eb1f"
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