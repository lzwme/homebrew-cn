class WindowsEsdToIso < Formula
  desc "Converts a Windows 11 ESD to an ISO image"
  homepage "https:github.commattiebwindows-esd-to-iso"
  url "https:github.commattiebwindows-esd-to-isoarchivef16d832b610a6f83b3adef6e1d425ee1a7674fa4.tar.gz"
  version "2024-01-25"
  sha256 "888e4f42abe204dc5b03b05422a1796be7240b5a11dbf8505427c846bf5936e6"
  license "MIT"

  depends_on "wimlib"

  def install
    bin.install "windows-esd-to-iso"
  end
end