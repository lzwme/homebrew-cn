class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.16.0.tar.gz"
  sha256 "80c07b7a92b24ac9661fa312f287f0900bbe19b9c3a2f4c2739a2f242a5558f9"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39b5caf7f831820c2db518e7e1d77c66a30001ec211c055a6bd8860548c3b885"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae645ea4a1ea31943d2336bf8fb84ac3057886ac90eba7ba41daa05a59b8ccc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a36bfa349c6e5f33cfe02a882134d482154b4e68bccbc1b9d2a83735d7da47b3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b04e210291567294ef7044ab30965cf96ad7131dfa4a6b39b9d52eeddf861c4"
    sha256 cellar: :any_skip_relocation, ventura:        "0beec480bcdbdd69bdd60ec161be330161dd42f542d799ccf45a92159fe8bcb1"
    sha256 cellar: :any_skip_relocation, monterey:       "e155fd48ecd8c1c856155ed3d0f5edb64e3543c0b64a4c076f70678db4a06525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a2f29edaa110bda4ae80d0125b65c85e070e10f9cca58a96261a6f1cd33b8c7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "manjust.1"
    bash_completion.install "completionsjust.bash" => "just"
    fish_completion.install "completionsjust.fish"
    zsh_completion.install "completionsjust.zsh" => "_just"
  end

  test do
    (testpath"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin"just"
    assert_predicate testpath"it-worked", :exist?
  end
end