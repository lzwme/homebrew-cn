class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.24.11.tar.gz"
  sha256 "84d8d8aad31661406d411624fe62fab5d10da33cdf4844d8de618d4fbbfa7b11"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d64cb76889fe51ce72c3c830387c77659f9c9965150407946f7b7ce523f178d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62389d68dd9fb8eb7e9846092c0509afcf459f72ad8418073e38a236bbfbacb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "00fcfc67e524f624077a4ce2d6102a1be3c72a934f5ec103dd98c579bdc25feb"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b1687f42565ed7684c4808238375b429a3ac4ceae1c32aa2af20b04d8e9190c"
    sha256 cellar: :any_skip_relocation, ventura:       "64427d7267c5a6e6f426216d6a0d2f39e80cfe6bf3c2e0520ee2bfe6c6519891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0df01564b106d386cf6ac9b659b42b6d013514a813038e743ab38971b8c9ac26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6051310da6928abd22df4daca4c6d120e5f879d75f69264e5fb71b3555093c7a"
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