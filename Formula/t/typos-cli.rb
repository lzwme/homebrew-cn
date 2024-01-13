class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.17.1.tar.gz"
  sha256 "69ba70ac73c29cb016764c0081541e852b45b764b25747cc4b12a5d86ee6cc7a"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "62c52cba3cb3e0efe123c6b0630088ba1f86b6e02244aa195fc3df7e079234e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11b874bd7c8c35c38232e39cba357d58f5c5b92ee27d16e156c17d60bf810fe0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eb7b3fd41e42f3119eb2c1e826a9865393a3c427c197a03b2b7a3cad39ab98e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6440e61b49087ec34222d32a0621c1e5bd0e1bf9df80c0984ea0695e6cef52a4"
    sha256 cellar: :any_skip_relocation, ventura:        "086c7a03ea3ecfb977a28a82033328a704d2e21b8a18b48414a332626523ba5f"
    sha256 cellar: :any_skip_relocation, monterey:       "b4db2bce0c8bd76efadfe92c137960973bc922be55e91439a5bce9609cede1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ab8d31a9e30023fc66b7ec8fa1307b9a47fbcd1693d42b3fc62dff5f12563c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end