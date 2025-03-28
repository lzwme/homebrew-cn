class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https:vapor.codes"
  url "https:github.comvaportoolboxarchiverefstags19.1.0.tar.gz"
  sha256 "f84f09c6ce7cbc6c7f6dd936fb3601bf2aeaaccdf50dc60c61e2b075579d0d2d"
  license "MIT"
  head "https:github.comvaportoolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd3ce2dbff951a219b81694a11800b6bf8aa0b3b7e124cebe7df37958ebbc51c"
    sha256 cellar: :any,                 arm64_sonoma:  "e047ba24b56f3a8333e4d97ea0a73fcf40c7d5b3c35ad8ea9db4afc28336ac6f"
    sha256 cellar: :any,                 arm64_ventura: "503f09c6e9c53d61444ef6aae85c6145acf1a99e21e3e52127121bee52d46c85"
    sha256 cellar: :any,                 sonoma:        "2d5a94f778e7198d9c5388565463b1a617b33f338b78d28a8af9cb2158cdf219"
    sha256 cellar: :any,                 ventura:       "cd73ad4ed509b15830c93c841a5b33e1a4324a3d2b896aef0f45822f6ec0b180"
    sha256                               x86_64_linux:  "32ec06c66e460924a58b2725672e11c4e38d14cd17a7ff7ff6a6c9d684b950a8"
  end

  uses_from_macos "swift", since: :sequoia # Swift 6.0

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "-Xswiftc", "-cross-module-optimization"
    bin.install ".buildreleasevapor"
  end

  test do
    system bin"vapor", "new", "hello-world", "-n"
    assert_path_exists testpath"hello-worldPackage.swift"
  end
end