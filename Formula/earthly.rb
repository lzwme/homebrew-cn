class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.13",
      revision: "d0b0489eaf39417d0a1d78943aed16210f8145bc"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40a8f67d5ac58b4721699dc1a1ee459c30e49541217bee46bdb2e68d7fcce235"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40a8f67d5ac58b4721699dc1a1ee459c30e49541217bee46bdb2e68d7fcce235"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40a8f67d5ac58b4721699dc1a1ee459c30e49541217bee46bdb2e68d7fcce235"
    sha256 cellar: :any_skip_relocation, ventura:        "4d5de2f314f5ae716b4ca60c01d83d7098e1f7186c97a242b15385cb5cca4acc"
    sha256 cellar: :any_skip_relocation, monterey:       "4d5de2f314f5ae716b4ca60c01d83d7098e1f7186c97a242b15385cb5cca4acc"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d5de2f314f5ae716b4ca60c01d83d7098e1f7186c97a242b15385cb5cca4acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd533bfa6b3e84423cb6000028817f12cfc25839059a99bdf053cc4e4dd55120"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.DefaultBuildkitdImage=earthly/buildkitd:v#{version}
      -X main.Version=v#{version}
      -X main.GitSha=#{Utils.git_head}
      -X main.BuiltBy=homebrew
    ]
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork dfheredoc forceposix"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), "./cmd/earthly"

    generate_completions_from_executable(bin/"earthly", "bootstrap", "--source", shells: [:bash, :zsh])
  end

  test do
    # earthly requires docker to run; therefore doing a complete end-to-end test here is not
    # possible; however the "earthly ls" command is able to run without docker.
    (testpath/"Earthfile").write <<~EOS
      VERSION 0.6
      mytesttarget:
      \tRUN echo Homebrew
    EOS
    output = shell_output("#{bin}/earthly ls")
    assert_match "+mytesttarget", output
  end
end