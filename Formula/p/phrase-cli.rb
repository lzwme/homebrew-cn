class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.35.2.tar.gz"
  sha256 "687b8a28bc66db778d89fa23d5e7af5460ac2134bd10678efa9b7e27f395b0d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4eb1f8fc48ecdb03afba63f6b65a8a805569fbef6ac779722575057aebca422"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4eb1f8fc48ecdb03afba63f6b65a8a805569fbef6ac779722575057aebca422"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4eb1f8fc48ecdb03afba63f6b65a8a805569fbef6ac779722575057aebca422"
    sha256 cellar: :any_skip_relocation, sonoma:        "dedf4cf02e7d31811772d827cac027c0287ddff85c06933afd3f5b3b755adb62"
    sha256 cellar: :any_skip_relocation, ventura:       "dedf4cf02e7d31811772d827cac027c0287ddff85c06933afd3f5b3b755adb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f5e7ad3dc4a7342ec550e7eb3732b783e5471a824734911761a5a570a8056d7"
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