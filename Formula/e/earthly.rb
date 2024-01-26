class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https:earthly.dev"
  url "https:github.comearthlyearthly.git",
      tag:      "v0.8.2",
      revision: "f991e7fc9261892afe82fe5b20a8952eed14514a"
  license "MPL-2.0"
  head "https:github.comearthlyearthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cdc2dea51736ed446a6acdd3250e1fe22d4851ceff797751fb0bf7a3ada1545"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cdc2dea51736ed446a6acdd3250e1fe22d4851ceff797751fb0bf7a3ada1545"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cdc2dea51736ed446a6acdd3250e1fe22d4851ceff797751fb0bf7a3ada1545"
    sha256 cellar: :any_skip_relocation, sonoma:         "15073d6f2552c660555599ae8cf28b6464402bb231e7bf64e0b74f69241b08fa"
    sha256 cellar: :any_skip_relocation, ventura:        "15073d6f2552c660555599ae8cf28b6464402bb231e7bf64e0b74f69241b08fa"
    sha256 cellar: :any_skip_relocation, monterey:       "15073d6f2552c660555599ae8cf28b6464402bb231e7bf64e0b74f69241b08fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99b519e6f58b840a64c1d81f4a7b07f24e9522548f8051576aecd61184338e76"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.DefaultBuildkitdImage=earthlybuildkitd:v#{version}
      -X main.Version=v#{version}
      -X main.GitSha=#{Utils.git_head}
      -X main.BuiltBy=homebrew
    ]
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork dfheredoc forceposix"
    system "go", "build", "-tags", tags, *std_go_args(ldflags: ldflags), ".cmdearthly"

    generate_completions_from_executable(bin"earthly", "bootstrap", "--source", shells: [:bash, :zsh])
  end

  test do
    # earthly requires docker to run; therefore doing a complete end-to-end test here is not
    # possible; however the "earthly ls" command is able to run without docker.
    (testpath"Earthfile").write <<~EOS
      VERSION 0.6
      mytesttarget:
      \tRUN echo Homebrew
    EOS
    output = shell_output("#{bin}earthly ls")
    assert_match "+mytesttarget", output
  end
end