class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.0.tar.gz"
  sha256 "a03744c2e8098d8a0ae9e6ae1636e4f27d7aba24a652b09e494a41eb82c64873"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86057f2e62434f0fc54207cc1f2c187059a55476b97d2b0d7db4e328d77bb3aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a1a1abfbd81fdde6ec5fd728092cc12ddb33f06e6015b77ae06c39ace03de90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f2617c6a3a8a5eca6af5603c8610c133f79c7ece1500a1fecee9017ad94d7b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "90f3d6cb672be92eb4397b766b1694f9ea62a686b2696ff2bcfea4bdddbb7ac3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b0efee713b683148c985efb4b9f9ab1d315a2146732faca353d311cca0e25b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70471878702707d2bc53e0ccc44ab3244a8afe0112a94f9ce356c3e883af1c24"
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