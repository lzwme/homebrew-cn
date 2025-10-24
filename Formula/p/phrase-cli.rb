class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.49.0.tar.gz"
  sha256 "fd42facc50f9b16a1880540739e0911b97b6799f8c7c2b92a419ac522fe48f5e"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "106b88d7f8c50ce3643e428cba010ce2a3a211859435caeb60beeec41c46d065"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "106b88d7f8c50ce3643e428cba010ce2a3a211859435caeb60beeec41c46d065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "106b88d7f8c50ce3643e428cba010ce2a3a211859435caeb60beeec41c46d065"
    sha256 cellar: :any_skip_relocation, sonoma:        "41d5f541a4c51c89b7f24a63e2e1690b937b1c4a1746667d26eac78dffebab66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e3e27abe17e2c672a0341bebe941b53cdb88d20675653824883688f20846b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b4d8bb7a78300af3e04c0ea7a3200ced7f344bf67609e8ef62c0df48126d259"
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