class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.50.1.tar.gz"
  sha256 "227f52bb4bd58d588df7ed0b49a8ed1b0e64dba390b5c6cfe80a370c507fe91e"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e522fde9ce3a0d35e24cb198122354e2b8d5062c341c0e8965ba61ddd1b9a853"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e522fde9ce3a0d35e24cb198122354e2b8d5062c341c0e8965ba61ddd1b9a853"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e522fde9ce3a0d35e24cb198122354e2b8d5062c341c0e8965ba61ddd1b9a853"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb7998846e2c15dc3b091a579c46bdf41cf90dfd5e9bf7e9a71c4612112aa9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "553c943ae65d29ecbb612b452d45c58ad76d43cf8689a04973cf1ee77efa61d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "002d4ce28933d62381192bab02fdd9be06a6e1e564d41ecec1235bc77c16ba1d"
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