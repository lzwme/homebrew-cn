class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.12",
      revision: "ce5e243a950f18da3d64c9a969ce18969a65d946"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e55006be7cc6e0b418546d0e2149d8b1350acec1d0cd4d10ea636d7f84189c8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e55006be7cc6e0b418546d0e2149d8b1350acec1d0cd4d10ea636d7f84189c8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e55006be7cc6e0b418546d0e2149d8b1350acec1d0cd4d10ea636d7f84189c8d"
    sha256 cellar: :any_skip_relocation, ventura:        "01b2b70e19fb6c70b40d9738905e3939bd6fc4965d9da6e57ee934ed6506785a"
    sha256 cellar: :any_skip_relocation, monterey:       "01b2b70e19fb6c70b40d9738905e3939bd6fc4965d9da6e57ee934ed6506785a"
    sha256 cellar: :any_skip_relocation, big_sur:        "01b2b70e19fb6c70b40d9738905e3939bd6fc4965d9da6e57ee934ed6506785a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d6f2005521857e3682ce2d60d79060c04dfbfddcdb4cc68ba3c2982356062a6"
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