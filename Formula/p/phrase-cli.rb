class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.54.2.tar.gz"
  sha256 "c89e65e9e6050ca677095dda8eb65e9d42c591a19faa317d74b703f1cedec81c"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "806613544f2c6e66baae53515f82f90a614e2ac95eb8b9b6b3f26a5f87a382bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "806613544f2c6e66baae53515f82f90a614e2ac95eb8b9b6b3f26a5f87a382bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "806613544f2c6e66baae53515f82f90a614e2ac95eb8b9b6b3f26a5f87a382bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb54e19e77cbc17bbe6ec9b9572cffe92f959018d03931f0f3c84ec1dd32b6cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "885cf3857f264a8dd1725d37461d3b21cd885746d8e7880c468d32ab3f630c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bd4aec22a1e5a227da0c4a2b24535209ef71e14a57a8126b974b2233fe57ea4"
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