class OsinfoDb < Formula
  desc "Osinfo database of operating systems for virtualization provisioning tools"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/osinfo-db-20240510.tar.xz", using: :nounzip
  sha256 "08a2d521c485687f6be39940d5b3f61bc0f583bb7e3655a131c658385eb7e5ca"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://releases.pagure.org/libosinfo/?C=M&O=D"
    regex(/href=.*?osinfo-db[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e882b6e0ef6b40d14000f2b644c3c08a8b31b043b16da0a99061ebab2e0cf9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5397eebeaec3329837cdbf2b34c1b1466b51fbc135ae4e03c070e1e964b942d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edbfddba870c0af89d7acc027fea1de62ee382c74d979bac002603d87b7b745f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9b29ed514da74c2ac8ae68b77c890c022193d191401d29183e4cf71463b487d"
    sha256 cellar: :any_skip_relocation, ventura:        "9ed1048c2e987684f1414705a2a779a4180f115c7872bbbd5ef36f27bc83bd47"
    sha256 cellar: :any_skip_relocation, monterey:       "c766dec8bc473cc48d046a6bd93c01790ba45decb063f017572e7f8341e87a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b34d0ec8dadd41f63b2c473928512a9e20c120bb6984cfdee2737c7baf38de87"
  end

  depends_on "osinfo-db-tools" => [:build, :test]

  def install
    system "osinfo-db-import", "--dir=#{share}/osinfo", "osinfo-db-#{version}.tar.xz"
  end

  test do
    system "osinfo-db-validate", "--system"
  end
end