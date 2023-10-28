class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://ghproxy.com/https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.14.2.tar.gz"
  sha256 "63dea3b89485ae417ba30712e1c898d8fb93d7bb14b14fe576d62b42bf8beb47"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3d97509030c7fe205db528e8a721779f996baee9178e648b5d896cca28de85bf"
    sha256 cellar: :any,                 arm64_ventura:  "bb420dfa19b74875873bb8ae163c5ebde49c17f82c990ab19cb77103ce70fe7c"
    sha256 cellar: :any,                 arm64_monterey: "033eac5fc9560e801edd519d11eccd91e54b7848fc035e3c6af8d5076195729a"
    sha256 cellar: :any,                 sonoma:         "2406f691200c97053887c5659e3f1f52aa413904a7ee64d000f1862fabc956d8"
    sha256 cellar: :any,                 ventura:        "40aafc727a110f10505ee6b7f4f6d051be72dc467b7c1d4a18f5cd09f608c060"
    sha256 cellar: :any,                 monterey:       "f87f6f0a7a57fb9a8682f9a685bdf7f576d3223480ec90c4bc605f3007c8ddaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13e24e0309f634de3154d601f9b65f5f915ada547c3f37340240f150bf89650d"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"
  uses_from_macos "libffi", since: :catalina

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec/"bin/pod", libexec/"bin/xcodeproj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/pod", "list"
  end
end