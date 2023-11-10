class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://ghproxy.com/https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1122.1.2.tar.gz"
  sha256 "f453e698d4c79bd3259dfd95a41ad987f9eac9728b8036a404ef23d08daf5326"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c66b393ebdaad1af53d68f0908e0c2d0ecf4065ec6d92e6904e3795a2129ed74"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end