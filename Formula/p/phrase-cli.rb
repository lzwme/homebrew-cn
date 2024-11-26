class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.34.0.tar.gz"
  sha256 "0a6ecb14be1d0454c837cc6c8f4ce244a2bd432c8c2ccbce5679a118eb251054"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6e9aeaf31bfda90f655b9a9720e456f3ad987e5fbb1e4dd165a47539a59ad8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6e9aeaf31bfda90f655b9a9720e456f3ad987e5fbb1e4dd165a47539a59ad8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6e9aeaf31bfda90f655b9a9720e456f3ad987e5fbb1e4dd165a47539a59ad8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce07fe202ed1bc611f4cc006304fd2b82fe545bcb8fd63cfc16467c376fb0fa6"
    sha256 cellar: :any_skip_relocation, ventura:       "ce07fe202ed1bc611f4cc006304fd2b82fe545bcb8fd63cfc16467c376fb0fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c8c8d8c5f4bc2de447ce8810e782ffc5c255fb6bba6e2e11b51a55c6f412cc4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comphrasephrase-clicmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}phrase version")
  end
end