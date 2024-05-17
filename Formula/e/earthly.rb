class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https:earthly.dev"
  url "https:github.comearthlyearthly.git",
      tag:      "v0.8.11",
      revision: "5caed354538447b7de4d85b59827709da23b6e49"
  license "MPL-2.0"
  head "https:github.comearthlyearthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd6433f19e0dbba7ca345c439615347dadff7dc3c6e99ad19de41a19c0a9e6f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd6433f19e0dbba7ca345c439615347dadff7dc3c6e99ad19de41a19c0a9e6f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd6433f19e0dbba7ca345c439615347dadff7dc3c6e99ad19de41a19c0a9e6f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3e8ed692ecd30bbf58c0f4f4fdb13959713cc1ed33aa82ebf675d7c5f8c0b92"
    sha256 cellar: :any_skip_relocation, ventura:        "e3e8ed692ecd30bbf58c0f4f4fdb13959713cc1ed33aa82ebf675d7c5f8c0b92"
    sha256 cellar: :any_skip_relocation, monterey:       "e3e8ed692ecd30bbf58c0f4f4fdb13959713cc1ed33aa82ebf675d7c5f8c0b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02852be2d117765254a6f756fbde238b0796c212f4ef4d492eb91168802647f4"
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
    system "go", "build", "-tags", tags, *std_go_args(ldflags:), ".cmdearthly"

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