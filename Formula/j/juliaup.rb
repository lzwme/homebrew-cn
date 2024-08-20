class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https:github.comJuliaLangjuliaup"
  url "https:github.comJuliaLangjuliauparchiverefstagsv1.17.2.tar.gz"
  sha256 "d0860697e70b5cf8c5ee8a529da82413317d996f3f1a34ff6a6fef3a4564bbd5"
  license "MIT"
  head "https:github.comJuliaLangjuliaup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d41bdfd7f7ba652446b670b8a410601ad44379d1f86a594e6419174a312f4b01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "753cd3433426889bca7a6665a25ccfceee41fb641968dcae8cdca36dca33a78e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9b090631eda2708cb7cf9a6a78913c74af75ecfe28ad47a9c8e0fc82881fd27"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a4c40665b79c0a6e324e9d6f9493dc9f971dc2b8799cba46d81c67a8d895da0"
    sha256 cellar: :any_skip_relocation, ventura:        "a1de3326207d9e52a85ea5665100a6281159be944e888f6d20b681c511b7bf1e"
    sha256 cellar: :any_skip_relocation, monterey:       "bcd412bb5a80bd74e848887883b58e182dad72847727fb7c9b34fe590fb5fe1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76983b25dd7d01210b0d075921fcc97dc06701d65c96e3ed7e5001d2825fc495"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", "--features", "binjulialauncher", *std_cargo_args

    bin.install_symlink "julialauncher" => "julia"
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}juliaup status").lines.first.strip
  end
end