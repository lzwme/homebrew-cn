class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https:opensource.apple.com"
  url "https:github.comapple-oss-distributionsdyldarchiverefstagsdyld-1165.3.tar.gz"
  sha256 "f2cd78cdcf9d63011d0cee0047033b0815355a9f5d25df2a0690b47a05602e5f"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3eee3ae6d13f59a9967d5d29f7e6b3a0f9c181caa2cd174d820e5c4c8e6e8356"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include*"]
  end
end