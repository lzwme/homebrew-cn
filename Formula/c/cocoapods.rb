class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https://cocoapods.org/"
  url "https://ghproxy.com/https://github.com/CocoaPods/CocoaPods/archive/refs/tags/1.14.1.tar.gz"
  sha256 "d321ddc9cfd3eba729d2c91e063fd63c6174d027be3d2635bae3ed4b7e952af3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c7c336c4337c302d3cfb29e1bc02853e7cca6d3c3e3f815501a51b05e9e8ae3b"
    sha256 cellar: :any,                 arm64_ventura:  "6f7f43a9ddc01c6457be1b7d8b4d380a8e0b1775a0781d1b3a77be98da003df4"
    sha256 cellar: :any,                 arm64_monterey: "3c965c80304e989c5c0ecf02c96c7a0d524dcb62c207ffebb7234197ca0c52ea"
    sha256 cellar: :any,                 sonoma:         "c573ccf8e2c6ecc8acc9aeaba3907704e4511ac4175b0b05b8f68d47381d7175"
    sha256 cellar: :any,                 ventura:        "28b7f7c37866df7556a66c610d1ca66661a4a6206d77aa042048a30c9c93927a"
    sha256 cellar: :any,                 monterey:       "c6c2b2bfd3832fbb34f18857dbba20e977c53b8074a828ead5b126638adab647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6998759886d81fa09e58e362d58fa82c3e62d8adec941092f1b78f1553871ab9"
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