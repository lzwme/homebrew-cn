class Bettercap < Formula
  desc "Swiss army knife for network attacks and monitoring"
  homepage "https://www.bettercap.org/"
  url "https://ghfast.top/https://github.com/bettercap/bettercap/archive/refs/tags/v2.41.1.tar.gz"
  sha256 "c00a489110a01b799796bfc5701bbaea882e0a1aa675d16ce2aba25bd0d71ad1"
  license "GPL-3.0-only"
  head "https://github.com/bettercap/bettercap.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "621bb685704def4c8be34da96de714b4edf0ac04154bd2c9463695951883e758"
    sha256 cellar: :any,                 arm64_sonoma:  "901bbb7d7876139268957e5d43a894ab9626455a57883af493c2924b33c6479a"
    sha256 cellar: :any,                 arm64_ventura: "daba887ac15d63596447f47f0b5abc5f45e20eebc0e67f59ecd63daff671e1d5"
    sha256 cellar: :any,                 sonoma:        "d04852a37bcc0926d9cda8036024e04f37455239e5d1f735010fc818ccdecb67"
    sha256 cellar: :any,                 ventura:       "0ab41470bf5828053907cb4d7e7235878950308ea1f42df6289b4360422f0ab7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b27de98d5ff8586d70b3a6448d663c7821926bbab32c6c49d0c7ff9abfd1d2d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b1ce57b33228eb4fbc74f6f384ed0712e56ad4929dff81e13ad9ad2924c7d43"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "libnetfilter-queue"
  end

  resource "ui" do
    url "https://github.com/bettercap/ui.git",
        revision: "6e126c470e97542d724927ba975011244127dbb1"
  end

  def install
    (buildpath/"modules/ui/ui").install resource("ui")
    system "make", "build"
    bin.install "bettercap"
  end

  def caveats
    <<~EOS
      bettercap requires root privileges so you will need to run `sudo bettercap`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    expected = if OS.mac?
      "Operation not permitted"
    else
      "Permission Denied"
    end
    assert_match expected, shell_output("#{bin}/bettercap 2>&1", 1)
  end
end