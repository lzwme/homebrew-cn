class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https:github.comdependabotcli"
  url "https:github.comdependabotcliarchiverefstagsv1.58.0.tar.gz"
  sha256 "453ae0c92e087ae73725e6fc0de5a6a0ac12c8922fbcaeaa58a468d465d9f35b"
  license "MIT"
  head "https:github.comdependabotcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdfb5da5f79606c92a625eb01eab33529d87717224883cbea9c6aa709bf1e915"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdfb5da5f79606c92a625eb01eab33529d87717224883cbea9c6aa709bf1e915"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdfb5da5f79606c92a625eb01eab33529d87717224883cbea9c6aa709bf1e915"
    sha256 cellar: :any_skip_relocation, sonoma:        "edadd93cfe95a533338771be8e3cdcfa234942318fa5e17d0ae13a66474ba6db"
    sha256 cellar: :any_skip_relocation, ventura:       "edadd93cfe95a533338771be8e3cdcfa234942318fa5e17d0ae13a66474ba6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc807ba84765f28be89518286a4fb802a53928a6b9d5ec36a679ee80aa7cf726"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comdependabotclicmddependabotinternalcmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmddependabot"

    generate_completions_from_executable(bin"dependabot", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix:#{testpath}invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}dependabot --version"))
    output = shell_output("#{bin}dependabot update bundler Homebrewhomebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end