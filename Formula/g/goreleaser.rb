class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.11.2",
      revision: "0c79877cda7594ad63c28e0151fa532b30ae2c91"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf1d5882fe0ac9585c25bbbd261189b44be763b511bb07038166098346567355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf1d5882fe0ac9585c25bbbd261189b44be763b511bb07038166098346567355"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf1d5882fe0ac9585c25bbbd261189b44be763b511bb07038166098346567355"
    sha256 cellar: :any_skip_relocation, sonoma:        "3affd5a92c9c94ae06c05b8820b0cbbb496bbffb03f9416bbfe7bb1fd1ae22d6"
    sha256 cellar: :any_skip_relocation, ventura:       "b8e13b645500d7cc097853b7853a4ba39519e03e7b2e520e80efdf6d40d18f94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60ba0e0d7f8dffdad62e426bc9692fc831b9790a5d9cd372effaaaec223bfe75"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end