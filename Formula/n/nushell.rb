class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https:www.nushell.sh"
  url "https:github.comnushellnushellarchiverefstags0.92.0.tar.gz"
  sha256 "7daa8bb7555ebb6c8af7ecbd531e8195504e466a22845e4a7e85e97e18bd504c"
  license "MIT"
  head "https:github.comnushellnushell.git", branch: "main"

  livecheck do
    url :stable
    regex(v?(\d+(?:[._]\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3fff58d5e590e0000153676e0622dea70d6fd8a5ef8a874e19b08ffd5fae9fc4"
    sha256 cellar: :any,                 arm64_ventura:  "536767163d5c647e98c53e293c722d9d309f74093ff137ec0cceb9485026bfd1"
    sha256 cellar: :any,                 arm64_monterey: "6f15e7d34ad5634e485c1d3a72e6e69374bb082603dde6d2e7cf63eddf110307"
    sha256 cellar: :any,                 sonoma:         "456462661b908d752f8188daf0d850d9b307e5afd4d05131c08510d718ce0d5a"
    sha256 cellar: :any,                 ventura:        "5cce07523fee6cc7d6b974a3aa543ac4a67adabb35df978071255544312930ae"
    sha256 cellar: :any,                 monterey:       "35cd6cdd7a8036352c878cb5b57f0462e74e5893dc6886852494324ad1b7efb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bccd6dc088cc458e482ecbaa5dc01dcea0639bd2884734a4f411ef7af81e27a0"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libgit2" # for `nu_plugin_gstat`
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "dataframe", *std_cargo_args

    buildpath.glob("cratesnu_plugin_*").each do |plugindir|
      next unless (plugindir"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end