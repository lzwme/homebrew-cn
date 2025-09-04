class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v2.12.0",
      revision: "9399b33c753bcf185fd15b23d224050592f83af6"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "829730ea63eb9e456f2826c2bbdadd46a140ce0ef28b345f17de21453e5497ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "829730ea63eb9e456f2826c2bbdadd46a140ce0ef28b345f17de21453e5497ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "829730ea63eb9e456f2826c2bbdadd46a140ce0ef28b345f17de21453e5497ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "9055fcd16b4f9efdfc2f23c2d9013fe8fc2efdfc84f7f4e8e8490bea27faf551"
    sha256 cellar: :any_skip_relocation, ventura:       "79b0ca4b34345bd200ff7738597f105537248d10ecdbb77afa6b9722e4c3aee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e38927f9bbe407bf770aef03e213bcb3bb63d67be2b66d3ef980cc5d196e92aa"
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