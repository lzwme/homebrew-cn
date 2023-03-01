class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://ghproxy.com/https://github.com/falkTX/Carla/archive/v2.5.3.tar.gz"
  sha256 "4fe6772a52e677c926c4d21ce10a20888ddab487b0bb9dd7314e262a3200a342"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "af4603464e92f63b973f418c6756e7b5ef0597fc68bde190537023533f4e71a3"
    sha256 cellar: :any,                 arm64_monterey: "5cae6077d549dfa5736c5a0a21bb0689cf09507664ee1c51e52913f2bbb04004"
    sha256 cellar: :any,                 arm64_big_sur:  "27e94c1b2b9c15483c29fc3a55e26ef05f6dc645eee27d2b11586a681ffb474f"
    sha256 cellar: :any,                 ventura:        "8e21634e6fb47bbe96c0ff3f64609b0d42ef5c43c3c02552e08fbaa2dc4eb80d"
    sha256 cellar: :any,                 monterey:       "55d77147433c3cb484c235e0ac5b306669e5a6d256e1fa6285189f236763a3e0"
    sha256 cellar: :any,                 big_sur:        "90e5abcd75da09eed552d1cb272353450af73af44118c04c8eb2b86567450728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "284aeaa8d6d5fceb4e2c6c5ab6c07143e238adf309cddaa8ecd79c4a8eb76adb"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.11"

  fails_with gcc: "5"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.11"].opt_bin}/python3.11"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end