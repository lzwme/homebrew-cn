class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https:premake.github.io"
  url "https:github.compremakepremake-corereleasesdownloadv5.0.0-beta5premake-5.0.0-beta5-src.zip"
  sha256 "660ba0dd472c06be59da60b78c3abaf8cef10a0a4f3b9ad69d8e34fbd190126b"
  license "BSD-3-Clause"
  version_scheme 1
  head "https:github.compremakepremake-core.git", branch: "master"

  livecheck do
    url "https:premake.github.iodownload"
    regex(href=.*?premake[._-]v?(\d+(?:\.\d+)+(?:[._-][a-z]+\d*)?)[._-]src\.zipi)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c9f73d9b341c41aeb0fded5ec2cb96bd685b95ca953e7b0549e514df6fee4b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0518ab18302f3ec9cbdbf975ab4bac0e8624e8542ab866b339d7767ba8e240e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "107601c18db6358eb5c08f9af54580f403963ad9e0e3b31bce8f8fd533be3920"
    sha256 cellar: :any_skip_relocation, sonoma:        "87d7e9f7355b28c92227d586cad85050a246981f8a2adef4072cc671808ace02"
    sha256 cellar: :any_skip_relocation, ventura:       "4aa55636996c684aa6b2bc1407021bc4f7338c96cc0c2aa781e5456d934b0966"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2db7770035d4f94103e9a41bb3b65c2aa757e28dd3a961475b21f26053ae4857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a94c1341ba63675c5f3289f5607fddb8da45da5125296ec7e6b0de9b28bc064"
  end

  on_linux do
    depends_on "util-linux" # for uuid
  end

  def install
    # Fix compile with newer Clang
    # upstream issue, https:github.compremakepremake-coreissues2092
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    platform = OS.mac? ? "osx" : "linux"
    system "make", "-f", "Bootstrap.mak", platform
    system ".binreleasepremake5", "gmake2"
    system ".binreleasepremake5", "embed"
    system "make"
    bin.install "binreleasepremake5"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}premake5 --version")
  end
end