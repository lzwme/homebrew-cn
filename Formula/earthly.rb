class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.7",
      revision: "547fb642f99f6b260aa19b00d7ae22eaafb2ba64"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "821c1a489cb9749534a30430a02173f01434c7b322e97c05c943d76b7ba9d4ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "821c1a489cb9749534a30430a02173f01434c7b322e97c05c943d76b7ba9d4ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "821c1a489cb9749534a30430a02173f01434c7b322e97c05c943d76b7ba9d4ed"
    sha256 cellar: :any_skip_relocation, ventura:        "b157a2ed4feb6e41f207f05e2da28e1d9d289a5df1ca8bfcce6dc892d92f8814"
    sha256 cellar: :any_skip_relocation, monterey:       "b157a2ed4feb6e41f207f05e2da28e1d9d289a5df1ca8bfcce6dc892d92f8814"
    sha256 cellar: :any_skip_relocation, big_sur:        "b157a2ed4feb6e41f207f05e2da28e1d9d289a5df1ca8bfcce6dc892d92f8814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd96210738d69d7f33de5892c933d4418546f5a014fdbedb92220f602488d3f"
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