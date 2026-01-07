class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.3.0/commandbox-bin-6.3.0.zip"
  sha256 "f5c32c8127bd5f9a6605a652fc6ae98b447c5e7e2d1bb94a7af4fdd13dc79dfb"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8419b618c9a01e94ba2f33be41ffc9af08ec6311f9cf42d829accdce35550b99"
  end

  depends_on "openjdk"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/6.3.0/commandbox-apidocs-6.3.0.zip"
    sha256 "853c0eb5cd80bacf8529fc640d0507e1c2759a51c181a49da01c7dc55779ab5e"

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