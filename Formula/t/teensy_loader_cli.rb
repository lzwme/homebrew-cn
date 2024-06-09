class TeensyLoaderCli < Formula
  desc "Command-line integration for Teensy USB development boards"
  homepage "https:www.pjrc.comteensyloader_cli.html"
  url "https:github.comPaulStoffregenteensy_loader_cliarchiverefstags2.3.tar.gz"
  sha256 "d9c5357d7e8b99e9a9ae93f5e921c35a133a4a5d399f57eec10f3a606be5d89f"
  license "GPL-3.0-only"
  head "https:github.comPaulStoffregenteensy_loader_cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31075e6eb9a92d0ddaa3b9505c00fd00c77b057dc817b192c02bb0a3c1bb9cd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "369f2615e61079c280fa552715b8a771d3f620f4b05bc494b45c568b8f647fb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a73f7e320626476c5bbf849d59794329cc55414f9e3dca28e4f6ff7f0e74720"
    sha256 cellar: :any_skip_relocation, sonoma:         "0beb513ca87f99ee2a03e3700570bb2e82f7f6905b2921a5a14a31df6e0f12bf"
    sha256 cellar: :any_skip_relocation, ventura:        "1800778350862ed8662bf3183296fb5ba2efc08a5d9dd4531f684639176d02ee"
    sha256 cellar: :any_skip_relocation, monterey:       "1ac5153cfe35bc276fc73c0bb14823f34bd8ae34b408ab81d3140df1db128d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "578d01b193225d1af0f017f21000dc19fa544e15c090af656869c1de14eb7f44"
  end

  on_linux do
    depends_on "libusb-compat"
  end

  def install
    if OS.mac?
      ENV["OS"] = "MACOSX"
      ENV["SDK"] = MacOS.sdk_path || ""

      # Work around "Error opening HID Manager" by disabling HID Manager check. Port of alswl's fix.
      # Ref: https:github.comalswlteensy_loader_clicommit9c16bb0add3ba847df5509328ad6bd5bc09d9ecd
      # Ref: https:forum.pjrc.comthreads36546-teensy_loader_cli-on-OSX-quot-Error-opening-HID-Manager-quot
      inreplace "teensy_loader_cli.c", ret != kIOReturnSuccess, "0"
    end

    system "make"
    bin.install "teensy_loader_cli"
  end

  test do
    output = shell_output("#{bin}teensy_loader_cli 2>&1", 1)
    assert_match "Filename must be specified", output
  end
end