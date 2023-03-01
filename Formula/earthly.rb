class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.0",
      revision: "cb2217400afdce4b49221dfa2eb64c06373141ce"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4e4ec0cb1b4da1fa27c312e707a055a99c525e07797de6ba2c33031d06684ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10a3c57c9b36912a73aaae841ecdf98acee2adbde14337481ab4acdfbac3fec7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4e4ec0cb1b4da1fa27c312e707a055a99c525e07797de6ba2c33031d06684ed"
    sha256 cellar: :any_skip_relocation, ventura:        "46d4e4cd0a00470944c3404f1beb24f068d2d67a6af809550f782805d6b856c4"
    sha256 cellar: :any_skip_relocation, monterey:       "61f4577ece5f2c51428f63d88cd79fbb2e5b73c82c98661ee07fac30b7fe0065"
    sha256 cellar: :any_skip_relocation, big_sur:        "30ad4a5db508fe43528583ec3ed869b28865cd902b12631f6ebbd990d6c6a6c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56532d5ec959716c5b1f275509b30b71864af8594835de27c74c7fcf7d8081c7"
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