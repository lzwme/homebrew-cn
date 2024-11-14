class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https:premake.github.io"
  url "https:github.compremakepremake-corereleasesdownloadv5.0.0-beta3premake-5.0.0-beta3-src.zip"
  sha256 "4b2b1fe9772ca1caf689c07e8c32f108b8393922956f602ddaf404f73467bd83"
  license "BSD-3-Clause"
  version_scheme 1
  head "https:github.compremakepremake-core.git", branch: "master"

  livecheck do
    url "https:premake.github.iodownload"
    regex(href=.*?premake[._-]v?(\d+(?:\.\d+)+(?:[._-][a-z]+\d*)?)[._-]src\.zipi)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fc61135e4dc02497cc901ea5e947c71c1d679ddce74a06b6debebbb91ee9b68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4181c30d8f5bf26a313bd09698e701029a4d7c5177d56807ad3f66f6572e621"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "488c6a7b28f8ca949c962103c9688670add748d067a3325f4b974c680376b32b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f4685956e6dda4395f48556328db9619a2833928553d08b54b8196666e8dd6a"
    sha256 cellar: :any_skip_relocation, ventura:       "01b4c6a57b7d41757c48749dc3da6d0eb29e590c685becd3d39e019ab1cee107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70279e7aab1b39c6428961e5b5b3ca0d4480cc637703730f87e0bc98c4a5477e"
  end

  on_linux do
    depends_on "util-linux" # for uuid
  end

  def install
    # Fix compile with newer Clang
    # upstream issue, https:github.compremakepremake-coreissues2092
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    if build.head?
      platform = OS.mac? ? "osx" : "linux"
      system "make", "-f", "Bootstrap.mak", platform
      system ".binreleasepremake5", "gmake2"
      system ".binreleasepremake5", "embed"
      system "make"
    else
      platform = OS.mac? ? "macosx" : "unix"
      system "make", "-C", "buildgmake2.#{platform}", "config=release"
    end
    bin.install "binreleasepremake5"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}premake5 --version")
  end
end