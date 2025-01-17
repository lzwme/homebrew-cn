class Rmtrash < Formula
  desc "Move files and directories to the trash"
  homepage "https:github.comTBXarkrmtrash"
  url "https:github.comTBXarkrmtrasharchiverefstags0.6.6.tar.gz"
  sha256 "24ba6b5982ded6429a2d8d86d9b5a9d83beb88b1b551a2152d0bc8177d782d2f"
  license "MIT"
  head "https:github.comTBXarkrmtrash.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "744e6e78555ccb8f228d62ffcba07dd4e58953bff858ec0faa5d6f066f49c394"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e35b0990862fbb7231249bca2fdf4b31dc626914d15b360e4c6ff6c939257974"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc23209fc8a50556566d5f44cd31defb56e4f060e44ea46fc4225d326c3c0c4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "65ee0247441bf614d5119a30f692aa757bff75d6723f7d71f56389e17bd37b4b"
    sha256 cellar: :any_skip_relocation, ventura:       "d8523ffcac38dcf23ee9c9245571373abc09cada9350350b9fd4a9ee6f075975"
  end

  depends_on xcode: ["12.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".buildreleasermtrash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}rmtrash --version")
    system bin"rmtrash", "--force", "non_existent_file"
  end
end