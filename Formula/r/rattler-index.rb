class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.25.6.tar.gz"
  sha256 "32f3ca5cd8063907bad80529a59ae56144d9a73db70bdc05d7805fc6f8243c54"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "866747cc1a69933857a34b8f4d272e2e428af57ab44b0b2782caa153009d5f22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "677c87ab4a8c4c778494e2820065fdf518e0f6746dc13d2a899738c0f514d764"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e00feb6bbdfb62aab33867e960e5542b18d88c00ee48127d4cf75ca5fc6964f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb52c92e91541579737905553794a58d24b20f739d0acbfcc46c6554ed92dea4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb9b9d8589aecf16dad0ec7c60df11cac224977912a25d9d15ae3e638227d2fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f04ac843f1d6f20487ede5de2a96f346c91b25764b27723392148703a5fe231e"
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