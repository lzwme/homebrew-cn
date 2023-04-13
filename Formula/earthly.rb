class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.3",
      revision: "18656a2d75d537bd5d5f85d8435976bcae0d3013"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19096e271032b4556d3488f4f317481dacd7d35d22663be6f6d7908584f41b2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19096e271032b4556d3488f4f317481dacd7d35d22663be6f6d7908584f41b2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19096e271032b4556d3488f4f317481dacd7d35d22663be6f6d7908584f41b2b"
    sha256 cellar: :any_skip_relocation, ventura:        "78cbb86cff4c2c4bb307ac533508bc52692ca0e567b4f2bcaa4d68d2a01c9dcc"
    sha256 cellar: :any_skip_relocation, monterey:       "78cbb86cff4c2c4bb307ac533508bc52692ca0e567b4f2bcaa4d68d2a01c9dcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "78cbb86cff4c2c4bb307ac533508bc52692ca0e567b4f2bcaa4d68d2a01c9dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83ffd58a9d6c1040222911d81114a78f40bd0cebcd4263b4fbd7f57f7046f3b4"
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