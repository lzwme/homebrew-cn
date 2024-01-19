class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST23, SF2 and more"
  homepage "https:kxstudio.linuxaudio.orgApplications:Carla"
  url "https:github.comfalkTXCarlaarchiverefstagsv2.5.8.tar.gz"
  sha256 "4ec96d06342ff28da4b80d4a76bc08fcaa5703726f96e5174afcdc4f7fc6195d"
  license "GPL-2.0-or-later"
  head "https:github.comfalkTXCarla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ec1291381e671d32533a89d49ac8422f0c33fb88f9ad4738798f011028c2599c"
    sha256 cellar: :any,                 arm64_ventura:  "56f402f64745b913bc0645dbf7fa8ba50ad420b982379c06a887d764bc873a03"
    sha256 cellar: :any,                 arm64_monterey: "929e274b0219f74c23be1c65f9cdda50e3b5f8b9ae38ffd1afc0f55d0f535213"
    sha256 cellar: :any,                 sonoma:         "3da956c57828aff90102bb0a76f37bfdf13b1b0dd0f5f6dfaf0a951e52aa7b17"
    sha256 cellar: :any,                 ventura:        "8f378e081f6fb5ab948a97d31741b42e6dc51cd273219239a1e24873b9cb9403"
    sha256 cellar: :any,                 monterey:       "2640474117ea51fa88e1289ee017bf440c6c00631339ddff05b9affa91e49f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "945471081c1fa496a673c4b0d86375612ff1198ccbe92dd799dfc93a8c2a893b"
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

    inreplace bin"carla", "PYTHON=$(which python3 2>devnull)",
                           "PYTHON=#{which("python3.12")}"
  end

  test do
    system bin"carla", "--version"
    system lib"carlacarla-discovery-native", "internal", ":all"
  end
end