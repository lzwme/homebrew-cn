class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https://earthly.dev/"
  url "https://github.com/earthly/earthly.git",
      tag:      "v0.7.11",
      revision: "4ee9f89698b37f680ae0062191f66e20c4dd997c"
  license "MPL-2.0"
  head "https://github.com/earthly/earthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea9fa8dd9fe9ebf25a11da4407ddef37ce688f6d12387f6261c3eeb61f36d814"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea9fa8dd9fe9ebf25a11da4407ddef37ce688f6d12387f6261c3eeb61f36d814"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea9fa8dd9fe9ebf25a11da4407ddef37ce688f6d12387f6261c3eeb61f36d814"
    sha256 cellar: :any_skip_relocation, ventura:        "8fe32f530b3909d7f4d416ed208e078799052a9343c680f49e62089a2be31ba5"
    sha256 cellar: :any_skip_relocation, monterey:       "8fe32f530b3909d7f4d416ed208e078799052a9343c680f49e62089a2be31ba5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fe32f530b3909d7f4d416ed208e078799052a9343c680f49e62089a2be31ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d9f5dfd75f677c97ddffb4b0c7f8134ec656322ff7ab7122da9c9a4c4dd6405"
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