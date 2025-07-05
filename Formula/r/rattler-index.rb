class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.24.2.tar.gz"
  sha256 "afe3220f7a6c3b3b96a473f6ac113c894dfce2207694b18f1525768636d8cdbb"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ade753cee3cc72889d33a0f9463fb033655f48b4c7f3679fa4196035ef63b24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df21a0bd8c971dac189205ed30d114c3568886201334c2da0709219b5ce4fd82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95127e85252f3606825310a65fa3b74996e88463badd42f97769b72b19f718ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "6489b0cd372ef57962df21560bd30d61ed06105b7a7d834aa88b783d028326d6"
    sha256 cellar: :any_skip_relocation, ventura:       "d4eed2500d79847fd34387970beddea4ce4a1b2174210cc95b2722ec91dfb257"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "337f489f92fa286d16b36e6cefa79fe4dc70537a08bf07d4527d5684341f45e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f59ab1009194c55dc18f976deff0284ec963f47c36205b6bdbe45cbcd96b7841"
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