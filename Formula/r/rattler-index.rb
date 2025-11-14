class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.1.tar.gz"
  sha256 "f96cbbefacad97438882d08835f4a419d38c0c8383cfbc37e12359cc31d5a859"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25598b75c9dfa2f6d55349b58d8984f07a1acb4f70b4bc235c954aa1732c6ab0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bbad93ad0b769f402c0b84f474a9c4cecdd21d4a7538134b9212e87d092cf1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "977710e9680974784c3bcdaaa4d20a3b51eb4d2cac979fbcb95d39369d0688b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "df3707ca94244ac015543c5565947ac3b6366103e08fafad9eab867b8b458b3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f34c984ac90b766a603ba94a101fa314174b32bcedbdd9dd291a5561a7869e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3cc822641fd234b7af208c9836e4fdc777995e16326249633c769c6a8eaace6"
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