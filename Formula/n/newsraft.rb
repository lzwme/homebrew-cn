class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.33.tar.gz"
  sha256 "096478f6516fbc4e70851f52f196c7a0d4853ef87331a7f796e6052fe65097de"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "113f256779da58c7b90c4391668ee98fd4699b1e3924dc2ec3289aabb93b19b9"
    sha256 cellar: :any,                 arm64_sequoia: "890c8b9f715dc1b5e1a582cf2b55fa9e1488c539b5cabb81c1444a828cd502f2"
    sha256 cellar: :any,                 arm64_sonoma:  "557db8cce2fdb93d264e6a4e5466c9a8c53c799bcc6fde7e67faec2a750f8e83"
    sha256 cellar: :any,                 sonoma:        "4d2bb7ff6f935c3d708483c5344fc0bffc0995da4b074f70a6254f291aa5914d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2574cb70f8e9d0309f00cad1a2dfe669396f6c068b58f7d6ca8b3574136819c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a161211d13e584349353730e8fbfbbf1a8fc62fd89c17ed503c20519024066b"
  end

  depends_on "scdoc" => :build
  depends_on "gumbo-parser"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  def install
    # On macOS `_XOPEN_SOURCE` masks cfmakeraw() / SIGWINCH; override FEATURECFLAGS.
    featureflags = "-D_DEFAULT_SOURCE -D_BSD_SOURCE"
    featureflags << " -D_DARWIN_C_SOURCE" if OS.mac?

    system "make", "FEATURECFLAGS=#{featureflags}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newsraft -v 2>&1")

    system "#{bin}/newsraft -l test 2>&1 || :"
    assert_match "[INFO] Okay... Here we go", File.read("test")
  end
end