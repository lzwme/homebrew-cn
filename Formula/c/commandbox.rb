class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.2.0/commandbox-bin-6.2.0.zip"
  sha256 "43cf4d34db625648b7e0c5fccba57324550e2c451190f25a7d2b80b7fbb985dd"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a5d7d92ce1b5bd1063083b4bdb52aeb740bd91c00ee093a3a55f731a7fa10bd3"
  end

  depends_on "openjdk"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.2.0/commandbox-apidocs-6.2.0.zip"
    sha256 "9be83e1950ebaed77bd8f705f527280fc1de86d1fe39acba422fcf6517475c74"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "apidocs resource needs to be updated" if version != resource("apidocs").version

    (libexec/"bin").install "box"
    (bin/"box").write_env_script libexec/"bin/box", Language::Java.java_home_env
    doc.install resource("apidocs")
  end

  test do
    system bin/"box", "--commandbox_home=~/", "version"
    system bin/"box", "--commandbox_home=~/", "help"
  end
end