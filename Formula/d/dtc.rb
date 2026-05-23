class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://git.kernel.org/pub/scm/utils/dtc/dtc.git"
  url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/dtc-1.7.2.tar.xz"
  sha256 "92d8ca769805ae1f176204230438fe52808f4e1c7944053c9eec0e649b237539"
  license any_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  head "https://git.kernel.org/pub/scm/utils/dtc/dtc.git", branch: "master"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/"
    regex(/href=.*?dtc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "133ee4841d6cf363f2b7b98e4d201dc1871e06dbee385543b3e3d5f892b4fa98"
    sha256 cellar: :any, arm64_sequoia: "4779a33b18a4e44c365d9ecd8f2788ec4c3d15e21552c16c53b41aa67dc46846"
    sha256 cellar: :any, arm64_sonoma:  "e6efb3fd92b69e97e9bbf4688aac3094407f712d37f40b57dca8f2b26131f7b7"
    sha256 cellar: :any, sonoma:        "9622337a07593353fe43755d48049544279456780bc9f9c2f536e8addbf9c401"
    sha256               arm64_linux:   "49e1b560741233f808f3b372a78c767b8033db1c57f5a45c2ee3e6c5193f86f6"
    sha256               x86_64_linux:  "e928d006c6c45bc690e91e6e918384ed2536873135305ee3ab92997bcb3e4491"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    args = %w[
      -Dpython=disabled
      -Dtests=false
      -Dvalgrind=disabled
      -Dwerror=false
      -Dyaml=enabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.dts").write <<~EOS
      /dts-v1/;
      / {
      };
    EOS
    system bin/"dtc", "test.dts"
  end
end