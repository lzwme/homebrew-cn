class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://ghproxy.com/https://github.com/simonwhitaker/gibo/archive/v3.0.6.tar.gz"
  sha256 "b5cd54a6e8503ec28abe2521b9dc59daffb392c7fa08fd88fa81ad2501aceb3a"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "666031e6ad852f4712fe1de6f1253d39a17d30331b1f9c3ad941b8b9263100ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "666031e6ad852f4712fe1de6f1253d39a17d30331b1f9c3ad941b8b9263100ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "666031e6ad852f4712fe1de6f1253d39a17d30331b1f9c3ad941b8b9263100ea"
    sha256 cellar: :any_skip_relocation, ventura:        "4a4468965c0376f3fa4532aeccbffdd4729ebc8f4eb90301221d6411411eb1fd"
    sha256 cellar: :any_skip_relocation, monterey:       "4a4468965c0376f3fa4532aeccbffdd4729ebc8f4eb90301221d6411411eb1fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a4468965c0376f3fa4532aeccbffdd4729ebc8f4eb90301221d6411411eb1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e8fcf3bc544e4ee15e680ff8d094c33537b0cf8115ad4a6579ee6733621bac"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
      -X github.com/simonwhitaker/gibo/cmd.commit=brew
      -X github.com/simonwhitaker/gibo/cmd.date=#{time.iso8601}"
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"gibo", "completion")
  end

  test do
    system "#{bin}/gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end