class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https:github.comRobotsAndPencilsxcodes"
  url "https:github.comXcodesOrgxcodesarchive3c6e47459cbca714b55b6a1538b2512f71d68ef3.tar.gz"
  sha256 "2e064d4e34cb7f689b0177ef0dda4077e921365d95027fa44b56b0d56c3e7a64"
  version "PR-370"
  license "MIT"

  depends_on xcode: ["13.3", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleasexcodes"
  end

  test do
    assert_match "1.0", shell_output("#{bin}xcodes list")
  end
end