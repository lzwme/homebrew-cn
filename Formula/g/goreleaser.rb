class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.13.2",
      revision: "bde54b47f0e27169880d43a8469f4d805942e2e3"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f5dc465f3320ee0cab97f20a2779c23746316af0282ff319ebca6cc11c397b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca7a8cd1cb3c8167865a03f8ddb0e017ee6c6e04e9bb29b5d114f40154d766b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1553263ea1191123f83f6f89c48134f506a8580f48d5be81fa685467db80929"
    sha256 cellar: :any_skip_relocation, sonoma:        "de20a5df2d7867fbfef9e14414c91e781e9cbda12431463396f38bc9e401764d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6205fdc953ee83344a6d929332c60042e026449695913318a694c074343a779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85fe398c663212e0d521b3991df03776beb88c24b2c06549c58371257ebe5d76"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"goreleaser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "thanks for using GoReleaser!", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_path_exists testpath/".goreleaser.yml"
  end
end