class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://ghfast.top/https://github.com/amadvance/snapraid/releases/download/v14.0/snapraid-14.0.tar.gz"
  sha256 "59e10835c0397193cb27969852a51059f0b0b9abb6cec2353f3052f6bd18e85d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "262fc436859c50ade4d5115113a6f8fb784a793cf5da2330d61f572c877b01e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3fe80e91f567c9ccd7963f62567d48535fc387e0a35a2abb99a6c5f9babb04f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52467f2bd42b6b0abdfc705b8d0fe6f07220fc96e9010bf47f6bdf64e2164725"
    sha256 cellar: :any_skip_relocation, sonoma:        "46d2d0118fd408f67507b7dc8694c97c13ead9f75529f4a2d78b473c3ab94e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "894937bd4dab5caf7a3425946771970be2e1c8415bfe7fafebfc9291b16e5766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "997c1ed9962cd493698124cea74af5a89e7da642c201e2a629d530bef0f3e311"
  end

  head do
    url "https://github.com/amadvance/snapraid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end