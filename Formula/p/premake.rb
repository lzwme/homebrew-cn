class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https:premake.github.io"
  url "https:github.compremakepremake-corereleasesdownloadv5.0.0-beta6premake-5.0.0-beta6-src.zip"
  sha256 "8832890451889c7ca9ab62c507d86fc9bfde45094274e5e4f46f82a258b5789b"
  license "BSD-3-Clause"
  version_scheme 1
  head "https:github.compremakepremake-core.git", branch: "master"

  livecheck do
    url "https:premake.github.iodownload"
    regex(href=.*?premake[._-]v?(\d+(?:\.\d+)+(?:[._-][a-z]+\d*)?)[._-]src\.zipi)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17a38d85ea292defa6e0f96af719c574203fe799a2bfcf3434f35ec4f4dbae4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5ca85506485fb7ba8ba9be1b0fde896f4e63487a7e2d144151c3820b0cf550a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b3390965bb92d8be8b1e44fd5456d79e0bd016c7ce6bf5033a94d4be02f3773"
    sha256 cellar: :any_skip_relocation, sonoma:        "5969d0aa6e3c766096136df6ea1a6bbebdcac14648295efb6c974b35203cb84c"
    sha256 cellar: :any_skip_relocation, ventura:       "9055d18a025e139f8327e74cb52602c70c179d6e4f9671b1fddfad947a9e8d6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97a3190152d567da4f60ef0037497d7b1569c3464811a9cfecf176b88da50bb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "023e7461f6a4cdac85ec71db6bef3889d9d1b0bca9c8f29dc570d0a45c087de2"
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