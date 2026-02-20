class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://ghfast.top/https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.27.14.tar.gz"
  sha256 "2950dd0a00cbcd6f8a138b1a6abb2d0ec8e3c94fa65058f8c6e6cef3e5c1f76e"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e7b4278fb9cc562ef329c8ea8299033828258eb4c0c497d7737cb037930eeda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6c366edfc4eba62b30ce96fdebca03c05cf9c298801b5d3aa7671f2f380eda6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "545d953b5db4a9d19af237e94eaab703f792b9d5252d92a8e689a06a024db421"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ba05f88d5ff73985241b158839f4dfa52cd03e10291949f1cbfd8f242c69c6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8a454ae415fadec2c9d787b5167b0b5b4b72fe540397dac62f45743afa9a818"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e017abda2bcda01673cc165a567482d5cf8df3f8e8404e9d8a00d9213d84ef3"
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