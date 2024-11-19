class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST23, SF2 and more"
  homepage "https:kx.studioApplications:Carla"
  license "GPL-2.0-or-later"

  stable do
    url "https:github.comfalkTXCarlaarchiverefstagsv2.5.9.tar.gz"
    sha256 "226fb5d646b7541b82035080190e7440df1f92372fb798b4ad49289570e5ad81"

    # TODO: Remove in 2.6.0
    depends_on maximum_macos: [:sonoma, :build]

    # TODO: Use `pyqt` and `qt` from HEAD in 2.6.0
    depends_on "pyqt@5"
    depends_on "qt@5"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "56213e765979dbe90d105907e5f9eb20d00f90290c63147d5c04de5ecf3d5baf"
    sha256 cellar: :any,                 arm64_ventura: "ea3005ad3619d14e4c1c7f75f60c9af86e0a21fc927ac5dd3dcf136ace5eef0b"
    sha256 cellar: :any,                 sonoma:        "6199f9867bff7d8fe10d49e29e46a5f3986f54ccb90c993398ab7b69e6d5839e"
    sha256 cellar: :any,                 ventura:       "20e04d81cc37f87d5277f7e94882d9d4b5bdda0f3c61e4ed2ecda1f4c85b3ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "133ea99c321c48bdba588d22f2c7ae064fb0d82730c815b1b6bb7f681b942c8b"
  end

  head do
    url "https:github.comfalkTXCarla.git", branch: "main"

    depends_on "pyqt"
    depends_on "qt"
  end

  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "libsndfile"
  depends_on "python@3.12"

  on_linux do
    depends_on "alsa-lib"
    depends_on "freetype"
    depends_on "libx11"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "sdl2"
  end

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