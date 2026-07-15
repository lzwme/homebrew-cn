class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://ghfast.top/https://github.com/amadvance/snapraid/releases/download/v14.8/snapraid-14.8.tar.gz"
  sha256 "bdf649024f6bcbf40261bc848dd6f9739152b0bbb1b074b3d88ef3dee00fe241"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c67ca75f161eab5a4b992c6b86cc1319c473c3d5afa11179a254b50683c6324"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b3f4cf658f6e724f1437218e15fabcb47dbd15c4e69b42d736fbb0ddf6bdb52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb030a1cf3e6b93f8f669a16fb870307b77777dd348ecd71dbaef1c1e4d70e88"
    sha256 cellar: :any_skip_relocation, sonoma:        "a921036c30cbf135f672635b544a285fe36def6506cdf484adf9d7dd668e568c"
    sha256 cellar: :any,                 arm64_linux:   "2cd7f8201d08f71466b07cf8e66bd2cbb8d93a5eff1b5ed3f7553e3cf2fefb31"
    sha256 cellar: :any,                 x86_64_linux:  "14316ad3476c304d0173820e5283332e39dfbdb5e55d533a760fa2e39f710c43"
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