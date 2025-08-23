class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.24.10.tar.gz"
  sha256 "6f866c858f323217b5572c50e7def9614580858a744c08074362aa09ad8c482c"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "684e27c7d1933eaac134827ba3c4cd9007b5be332198a08f5d40147594a405d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aca63c79ca9f8ce606f0de5246be3737feaa2a66c2789680be97eea0b34a6883"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cde667b6eadbe31c3ea375286cb94699a7b599630f8d94a8a009e9430a39203"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbf2860aa678536ee11e06d5e9c089b798f52ee0860a5e83a79dbdfb5c4f48ae"
    sha256 cellar: :any_skip_relocation, ventura:       "17ca3e246d8c61827c52f14185972415cfe7fd3c018b9ee61c49b46b370c64e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a99cbcc418cba1e7d10452615bf3b0f6db2eb32ea6b7ac38cc35238c90974ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccbe100b396fe47038986b1b38cb4365c0342d4eed8979286c97ba4274b98e62"
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