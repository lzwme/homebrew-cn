class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://ghproxy.com/https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-1066.8.tar.gz"
  sha256 "f5bd73aa970b3882520c308017688bd7e5fa5a0d3ad0727af4d053154add158a"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f833f5fe92cca8a389b735cb6510db079819a7d68659665af1fc79f29569114b"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end