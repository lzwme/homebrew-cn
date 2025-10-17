class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.48.0.tar.gz"
  sha256 "0784f31f5a186de7678f3bce3e29506facd0cd252c378c055c919fd3724756b6"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2aff87fff06f220d7f56e4d58f059be7610c013be3d50e404949a62a84b9abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2aff87fff06f220d7f56e4d58f059be7610c013be3d50e404949a62a84b9abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2aff87fff06f220d7f56e4d58f059be7610c013be3d50e404949a62a84b9abb"
    sha256 cellar: :any_skip_relocation, sonoma:        "929d53475575779bf50c83886852ab10d9a44990c4a0b73471a5334102373347"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a88431a4b8c5fd51c87fa2573b23be273c32d5c4836721dacfc1d788c8bee344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45d2b67e32811daa0908681107b7c72fdb6302c299129419c9cf26ae56cf8abd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end