class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://ghfast.top/https://github.com/phrase/phrase-cli/archive/refs/tags/2.50.0.tar.gz"
  sha256 "21e5f55f6adab9b4d7ec6d9147253ce1edb64020af4f26d8b43de7cbd3920359"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a7045010b73918bf9c5a7f4a4f6673c41c22255f64d7ea5c15c604d2e37da36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a7045010b73918bf9c5a7f4a4f6673c41c22255f64d7ea5c15c604d2e37da36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a7045010b73918bf9c5a7f4a4f6673c41c22255f64d7ea5c15c604d2e37da36"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce1ea255d06529f4d4e9d57dc946298b96c217306a09843ea58a0f7f08e937a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9c0df26d6b64ac595bb9bf3beaab472bd3d9a89fd9d59cd3c6e3a1ecc59ebb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9abca79a270b8d4726d42a3b4281c6ada0df9a16df7b93fd6d00293e8c34b69"
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