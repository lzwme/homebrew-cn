class Cocoapods < Formula
  desc "Dependency manager for Cocoa projects"
  homepage "https:cocoapods.org"
  url "https:github.comCocoaPodsCocoaPodsarchiverefstags1.15.0.tar.gz"
  sha256 "5133da7952299ee3880dd8fc9a1f1af26998b4705dd41b34a7f8e849f2d7053e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "21698eefc0c347e5da1a6de5421490897aaa77ec367e08584ae603b067b74b87"
    sha256 cellar: :any,                 arm64_ventura:  "84877a2908d3665f4f2af32b29aa7d37b8ee5a6381214b0938410c60871da85f"
    sha256 cellar: :any,                 arm64_monterey: "d123213d82066ca41bc5961ca6d26afc28c06a0aefd2b831c964175a5dee0da6"
    sha256 cellar: :any,                 sonoma:         "7a32dacdde0bf7c4de271e9e56df05300e19ebfc13f402a770dd22bca6fa02fe"
    sha256 cellar: :any,                 ventura:        "0155d3aa9242020a9794338e7bdcad5efa985a08af10bd8135b196bd7d40c207"
    sha256 cellar: :any,                 monterey:       "657fdd3e107087dce22a5484c1adc86f5b06530b2428cad70c49a5a6de302183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffcd84b2d766cbc07f24cf8fb736bc82ca3b352d9bfce5f6217aaed8cebef258"
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"
  uses_from_macos "libffi", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cocoapods.gemspec"
    system "gem", "install", "cocoapods-#{version}.gem"
    # Other executables don't work currently.
    bin.install libexec"binpod", libexec"binxcodeproj"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    system "#{bin}pod", "list"
  end
end