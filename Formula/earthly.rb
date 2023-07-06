class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.10",
      revision: "f862451125039f2071f26168ae9bc0e69ec24bf3"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0fc3eaabcd55771b05086ada3d44b2c625ff9f8f3e3214845a623a5f6c01bd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0fc3eaabcd55771b05086ada3d44b2c625ff9f8f3e3214845a623a5f6c01bd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0fc3eaabcd55771b05086ada3d44b2c625ff9f8f3e3214845a623a5f6c01bd7"
    sha256 cellar: :any_skip_relocation, ventura:        "e07680f18f6f5b84f66ae8be86975ea3fd13faa1548aface903df1fa84c0ef2d"
    sha256 cellar: :any_skip_relocation, monterey:       "e07680f18f6f5b84f66ae8be86975ea3fd13faa1548aface903df1fa84c0ef2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e07680f18f6f5b84f66ae8be86975ea3fd13faa1548aface903df1fa84c0ef2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26e3b0cb59f7bf1ad99472a22487fcbfe0f029107c2e5b19c8a3fd6725f9b522"
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