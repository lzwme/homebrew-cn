class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https:cxong.github.iocdogs-sdl"
  url "https:github.comcxongcdogs-sdlarchiverefstags2.2.0.tar.gz"
  sha256 "55869ffe12ad3b3bbe917b3f505a68a6d82e3bc4feab0609fd7e917d0c9db6fa"
  license "GPL-2.0-or-later"
  head "https:github.comcxongcdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "2aee4f3a7c8076f83797f61159b62abad042c2496e0352a4cb2ad36553cfd2dc"
    sha256 arm64_sonoma:  "c9b78c409281169e47c6c5111322cb40164582616eb1c38ca28a36cc38ce45f0"
    sha256 arm64_ventura: "e87e92c725502c1172a874301367ce5b69d56ac526684367a189916d2f82d1e6"
    sha256 sonoma:        "f22ed192583eb496d94ea91b1a7226e91a474f59312371c26d023fc25d84a094"
    sha256 ventura:       "f7f35f1394de64f69726049445c8866696a56c08fff58268c3d5841baffdc37e"
    sha256 x86_64_linux:  "88957e23c671be2430a0dd21030ae05f41159e0df25eddb6a28763ea449f92bc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.13"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "mesa"
  end

  def install
    args = std_cmake_args
    args << "-DCDOGS_DATA_DIR=#{pkgshare}"
    system "cmake", ".", *args
    system "make"
    bin.install %w[srccdogs-sdl srccdogs-sdl-editor]
    pkgshare.install %w[data dogfights graphics missions music sounds]
    doc.install Dir["doc*"]
  end

  test do
    pid = spawn bin"cdogs-sdl"

    max_sleep_time = 90
    time_slept = 0
    time_slept += sleep(5) while !(testpath".configcdogs-sdl").exist? && time_slept < max_sleep_time

    assert_predicate testpath".configcdogs-sdl",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end