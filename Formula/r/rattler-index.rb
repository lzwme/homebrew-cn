class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.26.2.tar.gz"
  sha256 "dab820229d448c079a098c0d1dae9608fa10b95ada246c9c792bf48b893b29ee"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94164c4ce999337830d8f5d18d26f19f34a9b927dd8fb2159ff8b2c1145d4edb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b617272383a28a1fb8b9d14f516fe4d206d3080810f393be0e774473cc6c437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f42d96e2df067e52f1719a29e883b8b6eff9597b970fe29349c4e1e0c1a4105"
    sha256 cellar: :any_skip_relocation, sonoma:        "431c26880dd60fed456c6a9210b5d7236513d9cc382377b2b2518d362b055fa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e2084ab638f20a9b52712daba7d6b2e474e7fa02776392d464858caae335b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1960f9326045023577cf3735909674497dcf2dff9e8efcfe5e4410de331302f5"
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