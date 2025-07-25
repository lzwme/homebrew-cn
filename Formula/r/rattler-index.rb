class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.24.6.tar.gz"
  sha256 "42b7effe7b0a6fa97e0f61e5119c964cc7209bef3a60f2ef1ddcc7eff84c7009"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "364cf96018f704523e0cfe6a163cee4c093d0317dab6002f000f49fd6bae8986"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33e95757b975794f060527a56705512f16947acf29dda1f7b8141c527bed0358"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2797de9ff092677e7c50a4311573fb46b0936b97351d9f46713501e7746a63af"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5f81611f57b736093f9f562ec304a80938670dff6a18d6de6b14c9323092497"
    sha256 cellar: :any_skip_relocation, ventura:       "35fe1b56307bbd920971be654d48b4472199b0000013947c6c800305210fd437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d390a2f1f84007593e4bdc0cdb45a833e899c28e30360bdc2d4b1281a038e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd1154ad96b3c74de2af2da8d6fa9e0fa401e04b313167adbe41ee300d326954"
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