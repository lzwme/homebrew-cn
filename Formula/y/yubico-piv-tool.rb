class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.4.1.tar.gz"
  sha256 "a1aa98b6b174eb2ba77f295e08c980598ba947f697b1b707ca08c76cf3ddce6b"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8fc324cd237ba65c80d9d6b2b9d9ed2df3efb8d150dc6b2e5e4ecf8e35c127d0"
    sha256 cellar: :any,                 arm64_ventura:  "ee7af99df3f48a534ab2767b012a8beebded7d94ee9c96d58575a43e845fed3a"
    sha256 cellar: :any,                 arm64_monterey: "a670150c6bc845b522946675a7a635e837c2630be9a28267c636c2b107fc8830"
    sha256 cellar: :any,                 sonoma:         "6a8991a904268e90986aaa5f348199fbd3420a00955c70e629e962fe55a7c722"
    sha256 cellar: :any,                 ventura:        "2d78bf194ceb6e1ebed18065eb584eb6a19c69e26cf53a0d16f6d9e3fecf1063"
    sha256 cellar: :any,                 monterey:       "1b95294f2a1b3b001daea36b6ec2c58afb7eae6681a649eb5abadcfce2f95298"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c441eef883cab98d42c6c5a0b1c84b0352a8f4d81b17167c513f83435a75e473"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@3"
  depends_on "pcsc-lite"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_C_FLAGS=-I#{Formula["pcsc-lite"].opt_include}/PCSC"
      system "make", "install"
    end
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end