class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https:vapor.codes"
  url "https:github.comvaportoolboxarchiverefstags19.0.0.tar.gz"
  sha256 "30bc592c82748459794be67b457a328f93afc9f6ecbd4ed9e267d1ff16456bf6"
  license "MIT"
  head "https:github.comvaportoolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a46e47be3d2250ce51a34e41e8f29d00cd87cc7f8b693942fe640034bcb47637"
    sha256 cellar: :any,                 arm64_sonoma:  "ee37255888c4b068b3d002b284ef469e4714762541a437fa58463d0bdfadfde1"
    sha256 cellar: :any,                 arm64_ventura: "4c982a9008de33951836fbb0a1b8b89c6e846304e4fb9cafd4ca11223f5fdee5"
    sha256 cellar: :any,                 sonoma:        "79e86e4f188d7f72b36f5cdf26439b309bcc195a55518894fc03bb2ab0256ec7"
    sha256 cellar: :any,                 ventura:       "a334109fa4c2f74b195d0a9b1318b027d0bfc93caad40d4e9f1a9391e4ec0bb1"
    sha256                               x86_64_linux:  "d276ef8fe4346dcdcf16f51887e2aae8fdf0f5ba774097ccc729a10f29c75399"
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