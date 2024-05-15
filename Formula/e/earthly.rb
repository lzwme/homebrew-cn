class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https:earthly.dev"
  url "https:github.comearthlyearthly.git",
      tag:      "v0.8.10",
      revision: "9050356a89d53c96ff94b6a46107274426353441"
  license "MPL-2.0"
  head "https:github.comearthlyearthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fea75566d96827d907e31ba3a1c5287fe3a819b2c8d9764b6df30581a5bcd4d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fea75566d96827d907e31ba3a1c5287fe3a819b2c8d9764b6df30581a5bcd4d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fea75566d96827d907e31ba3a1c5287fe3a819b2c8d9764b6df30581a5bcd4d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "cbe1cd398fe9cd04b33db8ee9288da44657c65262071dc8b2037c02fd22bba92"
    sha256 cellar: :any_skip_relocation, ventura:        "cbe1cd398fe9cd04b33db8ee9288da44657c65262071dc8b2037c02fd22bba92"
    sha256 cellar: :any_skip_relocation, monterey:       "cbe1cd398fe9cd04b33db8ee9288da44657c65262071dc8b2037c02fd22bba92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d08306848eadbf44467083b6118bf56387293255f639c3da1390569d000b1758"
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