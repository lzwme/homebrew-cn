class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https:opensource.apple.com"
  url "https:github.comapple-oss-distributionsdyldarchiverefstagsdyld-1284.13.tar.gz"
  sha256 "583a6ac254698f17feb7c8a83c364d242ab9185aaf4f73478056579da6bce968"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fcb398c76d5ef67211d4f30bea2475f9e60ceaa2d1351e133e3e0c12bbcb3554"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include*"]
  end
end