class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.63.0.tar.gz"
  sha256 "22fd5a42060d11ee0704f1d047d929e089420fbe140e2c47e2868cbc4da01320"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cd53f19c0125fcdb997923e8e9f2326fdacd1641f6f1a43f706389e81433c6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cd53f19c0125fcdb997923e8e9f2326fdacd1641f6f1a43f706389e81433c6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cd53f19c0125fcdb997923e8e9f2326fdacd1641f6f1a43f706389e81433c6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b7e66a40c68c0ab5740dfa6a75e52ec6f2456abe2d8ed39e14cdba0374c175a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2c9271aeb662efdc56a7712e7eb15215f1f98a18eb44b4250e7af62d1262662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f24577476496aca5b514bc17ea8d5f92520fde79a3b1e526633ec9ebb3a3b8b"
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