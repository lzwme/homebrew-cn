class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.21",
      revision: "f4c9f47e48c3815e95fe9574e824524d34a20219"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10ddaf73148c75755a13bce0e722c2e6ee8d12a92e1184a170aa4470edd9e3e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10ddaf73148c75755a13bce0e722c2e6ee8d12a92e1184a170aa4470edd9e3e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10ddaf73148c75755a13bce0e722c2e6ee8d12a92e1184a170aa4470edd9e3e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "05ee770e9f20caee1f8b3c249356c8a9743f2e47e4d267d0f417b3bb1c2a9be1"
    sha256 cellar: :any_skip_relocation, ventura:        "05ee770e9f20caee1f8b3c249356c8a9743f2e47e4d267d0f417b3bb1c2a9be1"
    sha256 cellar: :any_skip_relocation, monterey:       "05ee770e9f20caee1f8b3c249356c8a9743f2e47e4d267d0f417b3bb1c2a9be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07877d16a27077aecad41311a1684369107139b8fdc7eaf0238acacb016e74f8"
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