class Cotp < Formula
  desc "TOTP/HOTP authenticator app with import functionality"
  homepage "https://github.com/replydev/cotp"
  url "https://ghfast.top/https://github.com/replydev/cotp/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "8ef923c82397e1ce82b07cb1ac901a82c680d20cfd211d2f79b68a338006da08"
  license "GPL-3.0-only"
  head "https://github.com/replydev/cotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "68d1b25c6d5ec926d68d1f36b5b2d08c08700161fb5fe2e8ef841b653aa35ce8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6dfe12d41d465cc450bfdcf2798c90149841951d7b1a8c3c2467e0885e9035a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a80e1c0e9b9d3c434b32e6b6df638893d417ab07986af72ac06da3083f5bd60b"
    sha256 cellar: :any,                 arm64_linux:       "7f5444e5adce066e154b1a394106aecaf205bab507bb5c7e0c58478fa126d82a"
    sha256 cellar: :any,                 x86_64_linux:      "b71cbf3e4ec227d46ae3b209486d3ac164377bb6876abffcc4e64c77b50a6254"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Proper test needs password input, so use error message for executable check
    assert_match <<~EOS, shell_output("#{bin}/cotp edit 2>&1", 2)
      error: the following required arguments were not provided:
        --index <INDEX>
    EOS

    assert_match version.to_s, shell_output("#{bin}/cotp --version")
  end
end