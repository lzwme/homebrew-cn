class Pipebench < Formula
  desc "Measure the speed of STDINSTDOUT communication"
  homepage "https:www.habets.pp.sesynscanprograms_pipebench.html"
  # Upstream server behaves oddly: https:github.comHomebrewhomebrewissues40897
  # url "http:www.habets.pp.sesynscanfilespipebench-0.40.tar.gz"
  url "https:deb.debian.orgdebianpoolmainppipebenchpipebench_0.40.orig.tar.gz"
  sha256 "ca764003446222ad9dbd33bbc7d94cdb96fa72608705299b6cc8734cd3562211"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(href=.*?pipebench[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4e0843adb8181028ccf82ae98d94804996f5ca6f13bb2499049748de186c454c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b30b6b4a2108fbe48632fcb4c9a65a40d7dcff2e7757dd8b0ae67d5c9482d0ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09e7033208ec037cf78d7fca9c3ffcbaeb06a2a51ae8b6b53915c83b9745ed3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7704012e0f066c3a9ffa837df9e1f346a3dacbd37047aefce2d4d3f427e00562"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bb970ea3b27cad7960f3f60a86b3a55ad36d29cf11169019c5057e803d8ea75"
    sha256 cellar: :any_skip_relocation, sonoma:         "330b5c2d7b56101540829652a392086ca686b6c4154bf9b6cca81d607c14f89a"
    sha256 cellar: :any_skip_relocation, ventura:        "d9faf1c0f4d7a4986a7137f14eb3fe246351b594e64fe6bb07622b282d72da3e"
    sha256 cellar: :any_skip_relocation, monterey:       "f367e67b0def209b0553b577a767a8451f91f21d321f1addf6f01e5920c162dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e5856f67d0e9f663d04895b33cf50406b8fc584f2d01cf9c364b8a549620184"
    sha256 cellar: :any_skip_relocation, catalina:       "a7a63d8cdd084919304019c06290b7b808f637071c30f688219b47e2cc49f469"
    sha256 cellar: :any_skip_relocation, mojave:         "7489b10153744c61c74be048fb8c5d0acb4abae2f03437a0a633a312253c3345"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9ece6aaf7dcf0e1dbdbba28979ffbb6384f1d69aee8d194db2e009994c655cf2"
    sha256 cellar: :any_skip_relocation, sierra:         "213e31962005a876277c6f8edd3c9cd8964c253496f7945d48aef7338c76277e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "353cabdaf04a41e2169c1e489cd038f9fbe7f33cfd24a5a0b3068449ccc3446d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2230dc11d838a89ac74db6c346dee27398a0d4fb7377c93ca9f27876f51a6591"
  end

  def install
    # Contacted the upstream author at https:www.habets.pp.sesynscancontact.html on 2023-09-28
    inreplace "pipebench.c",
              "#include <stdio.h>\n",
              "#include <stdio.h>\n#include <stdlib.h>\n#include <string.h>\n"

    system "make"
    bin.install "pipebench"
    man1.install "pipebench.1"
  end

  test do
    system bin"pipebench", "-h"
  end
end