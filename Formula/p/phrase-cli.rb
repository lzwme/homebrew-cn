class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.53.0.tar.gz"
  sha256 "4928e5cf94abc50c1b576cd3a5a9f916f123d7bfdf4b0a9651581a8497c61341"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "040ee27cf1564039e6cd18095f901823f236eb3c5e8eb46ad819f77e6d6afdc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "040ee27cf1564039e6cd18095f901823f236eb3c5e8eb46ad819f77e6d6afdc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "040ee27cf1564039e6cd18095f901823f236eb3c5e8eb46ad819f77e6d6afdc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "99f9e2bc9c6b735081a90df58ace0366eee27d0d0f1e85df8c40ceaed1a63414"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a08198fedc64948d749b2f0a1ddfc4e7944b2b429f2565069305f5249e91da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e3baf00389252fabb777fc874ceb6aa3eeab724bc2aafba5bbb764e32e9b62"
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