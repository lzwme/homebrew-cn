class Cotp < Formula
  desc "TOTPHOTP authenticator app with import functionality"
  homepage "https:github.comreplydevcotp"
  url "https:github.comreplydevcotparchiverefstagsv1.6.0.tar.gz"
  sha256 "f6aca00525191d0d754a1d22785a9ec5b641593bdb3b34d06fcab58c21ac1d64"
  license "GPL-3.0-only"
  head "https:github.comreplydevcotp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7bcda4d28fa4adbb992c29410505267e40644df695a2f91006083956ca098ef0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb25532d07a6480a990b484c655b5592ce9a6e3441306e75b7a948a60b322923"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c5c0ab24fc246cad6530503bf3c46fcf1666daf28a089d636d3a0f35dff9b08"
    sha256 cellar: :any_skip_relocation, sonoma:         "f547c99bfe82ebec2d8db16583508214a8bbdd5cf1a63aa13fe3f90b4d962f31"
    sha256 cellar: :any_skip_relocation, ventura:        "3469c9bf00356218761b660c39373240dc28afb71f7dc601aab43be21892d284"
    sha256 cellar: :any_skip_relocation, monterey:       "d62ff3624da153cb0ab7cfb54e35ebd0bacef1f1a5361d7b4fa685b6eaa3fd71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "543307855f0743aa1b3f6b6d1a85950a282597768f0ce2742f95eb9419a60ab6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Proper test needs password input, so use error message for executable check
    assert_match <<~EOS, shell_output("#{bin}cotp edit 2>&1", 2)
      error: the following required arguments were not provided:
        --index <INDEX>
    EOS

    assert_match version.to_s, shell_output("#{bin}cotp --version")
  end
end