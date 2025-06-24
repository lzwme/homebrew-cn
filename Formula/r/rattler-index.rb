class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https:github.comcondarattler"
  url "https:github.comcondarattlerarchiverefstagsrattler_index-v0.23.1.tar.gz"
  sha256 "9a4f44d6ffbb49978f7535ee100ef1845d1570c4bedf8d959073e05e3ca651fb"
  license "BSD-3-Clause"
  head "https:github.comcondarattler.git", branch: "main"

  livecheck do
    url :stable
    regex(^rattler_index-v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea6a07727ab821bd5a0df62f6c1100c293cbe288d2069f7352e3ddd9b65f95e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10e4faa00b490a972d516efb9e27ed8f33219b7a331fa5d510973264ca914e62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f48bb20d9978b346c7e72bfbcfa3615884a56cfec6cec187f3ef84337e20cc0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2190b25d5cfaa0484faf506b1deede0644e04cddb53c64fe690a240201be9d18"
    sha256 cellar: :any_skip_relocation, ventura:       "115356a058227f7664e27ee47bf16016647ea258fa337c5653007f9bbce44c07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f42acfee309812ecc92cea30026a214a390d8bef0c42b093684dcbced346dd47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "173513cde055c4f468e3e1d6083868b505ad87f4f82ecd1c9342720aa59eeddd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls", "--no-default-features",
        *std_cargo_args(path: "cratesrattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}rattler-index --version").strip

    system bin"rattler-index", "fs", "."
    assert_path_exists testpath"noarchrepodata.json"
  end
end