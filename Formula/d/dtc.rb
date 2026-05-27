class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://git.kernel.org/pub/scm/utils/dtc/dtc.git"
  url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/dtc-1.8.0.tar.xz"
  sha256 "b298e24ce4824bd2e2af60cf6a3d2815e555b3e44c431eadad0b52798c83a833"
  license any_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  compatibility_version 1
  head "https://git.kernel.org/pub/scm/utils/dtc/dtc.git", branch: "master"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/"
    regex(/href=.*?dtc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c79f2ad44942a6cb4848a1f54a8a9102d84d4ae7d9d1708b492078a609a57edc"
    sha256 cellar: :any, arm64_sequoia: "1fdf5d3e57d68b4caea46c0ed88d4f0df0ec1832c4d465f663ca96a87bcfacff"
    sha256 cellar: :any, arm64_sonoma:  "7106d0b0d8f1c696063b0f96e87672e9e30caece6aa7a69897b6b945c84c32d5"
    sha256 cellar: :any, sonoma:        "2a14eb58e013bb553cd56d336b6f35e8b514155b93606392e069cee6678720fb"
    sha256               arm64_linux:   "922c0f401b78e666fea4c07a176a8bfb336a2bdd14c532e7aba9b65818037f44"
    sha256               x86_64_linux:  "ddb4a660c0af9334566d919b1198760ee0becc107b87b35a0b4a20dfb17b026d"
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