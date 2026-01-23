class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.10.tar.gz"
  sha256 "366db27ed1e62267f8e6e678c005a28a0745c2b3096db46c371ac71f771212e2"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08e46ac4e1dcdbbb3019f668422aadc9dbaf877ab2c87f3053ef907e1bf3da7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e87598422139d0ad90c847b85062fcbb48f236b42d7403a23f3947b7eb20c49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61219872b8c40d70c2aacd253f0653ac6ae6411e3d56350ba3b1fee026a5aa53"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd6ff1d685f2b8601069e656262f74aeaa4b8edfba057291efc7d05adce6b903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7460c781772f327e0fa95b18c0972c1f61deaa49e67b6f8468aab687672f3255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7523f302c609abbf33974e35fc74a90e8ac3a9fb6780f1560715e0fe643c744"
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