class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.12.6",
      revision: "4e5d8a2c0054ad8d1fd021c247bd26da183c9fcc"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "181c39ac4ad6b70b7f5f74ca0b62c868baeb98c76e8e01aae876ada3101ac6f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "181c39ac4ad6b70b7f5f74ca0b62c868baeb98c76e8e01aae876ada3101ac6f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "181c39ac4ad6b70b7f5f74ca0b62c868baeb98c76e8e01aae876ada3101ac6f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "573070091c3510f0fd80aea86c31f74f51c0142b86ec1f654c3017a6add63e45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b4e7d4ea4da9a559a272d9393af9553cbb943ea18ad94abd5115c10a40eeec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "518f8953c8df7ceec95993b54906d179e4ebd0916441f962fd1f4298034e7c4e"
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