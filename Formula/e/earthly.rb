class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.22",
      revision: "5763a1bb41dfa3fb7246d657962da06295cf83d7"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89fc8e59b712bbbb0fc9e4c86a7f704260ec0c1532d8174f76a2883e233575e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89fc8e59b712bbbb0fc9e4c86a7f704260ec0c1532d8174f76a2883e233575e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89fc8e59b712bbbb0fc9e4c86a7f704260ec0c1532d8174f76a2883e233575e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "1de4f4fc78c611ca4e80877fd883d4169b6db28556ee4a50d97d807020508b6f"
    sha256 cellar: :any_skip_relocation, ventura:        "1de4f4fc78c611ca4e80877fd883d4169b6db28556ee4a50d97d807020508b6f"
    sha256 cellar: :any_skip_relocation, monterey:       "1de4f4fc78c611ca4e80877fd883d4169b6db28556ee4a50d97d807020508b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f25fda9e406e3676e249af40658f6716fc2e17e3b141345353aa4bc7f127bcbb"
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