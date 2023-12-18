class Zoxide < Formula
  desc "Shell extension to navigate your filesystem faster"
  homepage "https:github.comajeetdsouzazoxide"
  url "https:github.comajeetdsouzazoxidearchiverefstagsv0.9.2.tar.gz"
  sha256 "a6c2d993a02211c3d23b242c2c6faab9a2648be7a45ad1ff0586651ac827e914"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "130c9a0c0e3c4cf09388bb04ee722140508e213949ebb92efda5f57fb897481e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49f1719c65eec1a3657c6162bb1f768717101df99d7ca3441d305fd3c80fea51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d88fcbbcfb4ec79355338a1c908c921d32b918495fdaf52adf2494a35cbd7b86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af613b9c960a8e755619f1f0397c897fd6f5d15c8f53ed7ffa12ec0202be7f7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "02ebf032157f82cdab906109a76e98b7a8ad9665966fcc5793295ce7e31d0e13"
    sha256 cellar: :any_skip_relocation, ventura:        "167c8f49d8e8139de86afb96d825de815332adca5960ddb92260b4d51e464fd3"
    sha256 cellar: :any_skip_relocation, monterey:       "3176f2c6aa53131db5502c455495f5ebd3be869468621b2e37c53b054a37b28d"
    sha256 cellar: :any_skip_relocation, big_sur:        "43fea705f20177f4e8b8558a00679ee016199f3787389040e7c8d7944a545953"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "657c7e0554270cf878dfc3ab249ab7721842655464ecb302e48737c1a8f76f42"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "contribcompletionszoxide.bash" => "zoxide"
    zsh_completion.install "contribcompletions_zoxide"
    fish_completion.install "contribcompletionszoxide.fish"
    share.install "man"
  end

  test do
    assert_equal "", shell_output("#{bin}zoxide add ").strip
    assert_equal "", shell_output("#{bin}zoxide query").strip
  end
end