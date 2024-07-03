class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.30.0.tar.gz"
  sha256 "2db1cd6a6cdca1b4f5858986ffd7ec7e56ba8ee1e7a6716d20ddb0e88a4f9b2a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b26881d1d3718ea88379331dbb74302af383dc705077f208b263e1c0033815c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d656120e82e754b61cbc7cde6eb81b84b96f4d2715fdd9044fa68a44c8d476d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8354133f82efef5b96fd42bbc7ace630cc4f8b52423b995838355383da4867a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c65d9cb35a83c654751cf724fd64950d4f5a68a011e3f4ec87726b558dbd6b62"
    sha256 cellar: :any_skip_relocation, ventura:        "8fdbf880c87f65323e566c274a2ffca0a69d09a7b92d354e50c7dc0bee91a453"
    sha256 cellar: :any_skip_relocation, monterey:       "c5bc0e2ccd589e538fa0900bd8d2fc0dd20a30114bfcb8a3d1735866693ff7ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "401196de00f4d41c6c3e57a8b22b7f6239430c58eec22bf0b64bfccd680daeb2"
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