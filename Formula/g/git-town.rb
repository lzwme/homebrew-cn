class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://ghproxy.com/https://github.com/git-town/git-town/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "44384657e15996492e3ee4ec6d960cbbbd052d23f4171166ea9c3ae258e6f091"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a39e5a77bf831871b1283995c102f2bf93399b748a161a68413739442e4bbb42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f73aaa3455f9634e9a8ddfad4f52b2e4076efa7cec81cf474be9d20e14d896c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "948663c432a273f7258277def559d64930d64ca12b4e9506e760dab03d685259"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f4e24e7e3cf8d1ac926197690b08314013d88b58a12f98cb21951f549e7ca57"
    sha256 cellar: :any_skip_relocation, ventura:        "756d69021c42f34b553ca5c871e33a0aaddc75651d5593cc4bbfca96fa300585"
    sha256 cellar: :any_skip_relocation, monterey:       "6682eaf0f79d514534563cbd35e36544454b6ef3a90b17977ca040f4371d2acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46ea89f30e9460949a813576959ac2a22b7ab8599f091a9836499f35b744468"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v11/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v11/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end