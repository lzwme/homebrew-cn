class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.24.3.tar.gz"
  sha256 "27c6778b694f48d0b6e14cf9002593b36bc751ddb09efd47feb80b538f3c263b"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a084c58a8f760c7f9309d8efd526c752c77cf3bffe80013e0525a5d1a66f71c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ceb2566830f17280f0481aba1364d98a8704954a8f5a4c345f949df72c2a5483"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec634f5c0ac6a7806e167e20f3119d2a23d46d3eb56731606ee8e13a3f417331"
    sha256 cellar: :any_skip_relocation, sonoma:        "2054cb21f6f1fb0ebd3ae534cb26d0efc9f66d0e34387d53f788bc93791d1944"
    sha256 cellar: :any_skip_relocation, ventura:       "d634d47c1d179c0d440e9e3c1520f6ae3dc161faaa634a82a6a40818ad2973de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "401b93d2f4fc81bb4838f2b0e032dcd9ac2717a724081a885e91e33bf0f573b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fb516fd20b7223a3393dbdbde0f22c170989b67258d6afbdf0280e40b203447"
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