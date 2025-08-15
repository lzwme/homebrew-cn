class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.24.8.tar.gz"
  sha256 "986109d916e346ca32624583740d9796aab2ce819d84d37dd5300a09127d1e72"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddb201b9136f1abbfe89c652557cf7eeb0bf56f4e9073c11c0e8625e26be1455"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "387852933a432c139fb598c321219744a4e03210d4c479dbb0d8f97b6defce30"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee8cd1c7ca427c8769fe5f877ebae70d0c6b11487c1747929ad70b1d9aceae0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3337b039073ac30f2fef7dcb9cf7736224af5a38803be23a2aedfc2164c1264"
    sha256 cellar: :any_skip_relocation, ventura:       "e54f4ee261e3aeecf01bdcb35535cad7b0425ed51b6a8faf49fec5ce15883922"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72c48536275ba2e969c6c3bfd45e1d88ee9155fe9e648557cb56530e18325dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d78be8d232b84e64b8e08de07726b5eb7b79b84c7d34388b13b221b6e34f4802"
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