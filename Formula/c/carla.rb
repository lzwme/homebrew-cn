class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://ghproxy.com/https://github.com/falkTX/Carla/archive/refs/tags/v2.5.7.tar.gz"
  sha256 "e530fb216d96788808f20bd7aaac8afdd386d84954ae610324d7ba71ffbc4277"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "8b1fc019e03ccb20df662d8a812c47fe7c188b75383a401d75d8f08f46a34e7c"
    sha256 cellar: :any,                 arm64_ventura:  "346b3100b75135bf0708a71777b064a5fffdf485f46df9d1e0f1b6eca7176966"
    sha256 cellar: :any,                 arm64_monterey: "fa8df3a4b3b54e3c5449ca7225deba9221c88542db3631120ae0474056d992bf"
    sha256 cellar: :any,                 sonoma:         "6cf1daeb9bd989e3bde1c85d326ec16cc1ef3b993ae6d13ce09be6441f4847dd"
    sha256 cellar: :any,                 ventura:        "8161e588f71b39dd0e9214b12ba0fecafe6da329230ba4f5d378b05d738ab6f7"
    sha256 cellar: :any,                 monterey:       "72cc42ad4923546fc5f17ef02d40e28a213d57ebfd5f7df5faa347afbacaf74f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "638fae24097e8ce2cda757e0df55b2b92b079a6b5f36988e0db75213821e9f48"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.12"

  fails_with gcc: "5"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{which("python3.12")}"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end