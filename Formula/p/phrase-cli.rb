class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.58.0.tar.gz"
  sha256 "0d125a8d2eb2203b03ba59d0cbd57db519ee177390d1554f573cc0318db27337"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c97a8f71b3b93753e498dee1e89b9debd8db43e7816de3748c8e0d6629000e0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c97a8f71b3b93753e498dee1e89b9debd8db43e7816de3748c8e0d6629000e0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c97a8f71b3b93753e498dee1e89b9debd8db43e7816de3748c8e0d6629000e0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "96e209a2b5700bb6b56774e9e2d247ba3ae3f076e7c429ce7f30f19588bd4d85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20738ff684f4f37f07bbcfebb7fca492982445299b73406ebcebf19bfbcf07e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dbfc9b20b30d56706149c8303291c294ad376035a610af3d56cb96312207967"
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