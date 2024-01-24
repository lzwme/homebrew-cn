class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https:earthly.dev"
  url "https:github.comearthlyearthly.git",
      tag:      "v0.8.1",
      revision: "7a66901de1313a6bc80185e6fa4aa6f2aca267c3"
  license "MPL-2.0"
  head "https:github.comearthlyearthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "596cd62a1130a50c8f40ca293ae0c212ddd87e53daea2059824d48ed3325d296"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "596cd62a1130a50c8f40ca293ae0c212ddd87e53daea2059824d48ed3325d296"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "596cd62a1130a50c8f40ca293ae0c212ddd87e53daea2059824d48ed3325d296"
    sha256 cellar: :any_skip_relocation, sonoma:         "439f401b0d722af3f1a339585d2a4d83c93cd7853f225df55d7bf932b74cf75b"
    sha256 cellar: :any_skip_relocation, ventura:        "439f401b0d722af3f1a339585d2a4d83c93cd7853f225df55d7bf932b74cf75b"
    sha256 cellar: :any_skip_relocation, monterey:       "439f401b0d722af3f1a339585d2a4d83c93cd7853f225df55d7bf932b74cf75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99a56692648cdae5a7ab5b27e260357abc3871d1beeab259d923f00a5cb031c1"
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