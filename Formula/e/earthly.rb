class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https:earthly.dev"
  url "https:github.comearthlyearthly.git",
      tag:      "v0.8.0",
      revision: "c23e2735fdceeb3f17bae3746a05cbc8e98fafe3"
  license "MPL-2.0"
  head "https:github.comearthlyearthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65882c9b9e33dfd16b09411d2fb4aca64361fe9f48462fd8278b275cba24f30a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65882c9b9e33dfd16b09411d2fb4aca64361fe9f48462fd8278b275cba24f30a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65882c9b9e33dfd16b09411d2fb4aca64361fe9f48462fd8278b275cba24f30a"
    sha256 cellar: :any_skip_relocation, sonoma:         "964d4fc3d89cc32d9296d97fe7bdba550496d5a8b3ec264c1e3e6e246efe6443"
    sha256 cellar: :any_skip_relocation, ventura:        "964d4fc3d89cc32d9296d97fe7bdba550496d5a8b3ec264c1e3e6e246efe6443"
    sha256 cellar: :any_skip_relocation, monterey:       "964d4fc3d89cc32d9296d97fe7bdba550496d5a8b3ec264c1e3e6e246efe6443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe000edb7767d9acde5db49f9e7b22099a6019faedb281f8d9ee5a3eb2df266e"
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