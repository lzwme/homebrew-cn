class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https:earthly.dev"
  url "https:github.comearthlyearthly.git",
      tag:      "v0.8.7",
      revision: "c18f025070261439c15a97897a8940cb109ea7c4"
  license "MPL-2.0"
  head "https:github.comearthlyearthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d1a057661b7f290bd2fa0743ac987cc355bdae5490ba72c30c2005ed27b9b4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d1a057661b7f290bd2fa0743ac987cc355bdae5490ba72c30c2005ed27b9b4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d1a057661b7f290bd2fa0743ac987cc355bdae5490ba72c30c2005ed27b9b4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e34960bcd1d01903eaf9d7c7534fb6cc322db3ff0744dd02bf4d27830c8bdf86"
    sha256 cellar: :any_skip_relocation, ventura:        "e34960bcd1d01903eaf9d7c7534fb6cc322db3ff0744dd02bf4d27830c8bdf86"
    sha256 cellar: :any_skip_relocation, monterey:       "e34960bcd1d01903eaf9d7c7534fb6cc322db3ff0744dd02bf4d27830c8bdf86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "328c8fdd012252dd7850528edcb664dbaa49da826a124a3ec97e552bc4e57008"
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