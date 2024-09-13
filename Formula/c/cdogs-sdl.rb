class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https:cxong.github.iocdogs-sdl"
  url "https:github.comcxongcdogs-sdlarchiverefstags2.1.0.tar.gz"
  sha256 "ea24c15cf3372f7d2fd4275cea4f1fd658a2bd5f79f7e6d0c8e3f98991c60dc2"
  license "GPL-2.0-or-later"
  head "https:github.comcxongcdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "daa0db61a75be661da8b47c0b894c7bc4ef0e362d28fed6dc31c60e7062634d0"
    sha256 arm64_sonoma:   "424f873fb1a12d1fce9e007ffecd9645ad8fad1ab19609867ea764725f77677a"
    sha256 arm64_ventura:  "c2478e77690ac1567728f8335d25c6c331605ded14c2442c5d9d65873d02cae9"
    sha256 arm64_monterey: "06ae6bd346cc553fcb28f25820169b526662bb7ff3df7d5a73b311e0022655db"
    sha256 sonoma:         "a901cac35e0506a8c7d6462e77c0321a804174f42cbcc5d9e326fb2e76e91301"
    sha256 ventura:        "3e85d05df5d451c8f6d56bdb5aa3e43c2e26294007f8210ca4be68eb44a925b9"
    sha256 monterey:       "0475a20d674cc4ba17cfcdf4a2b940acbaf843fdecdec18c0420504572baaac8"
    sha256 x86_64_linux:   "01a97639b8274ece35b78b9ca91d2bf193be332af2196e3618e0d0842df1bcd2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.12"
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
    pid = fork do
      exec bin"cdogs-sdl"
    end
    sleep 7
    assert_predicate testpath".configcdogs-sdl",
                     :exist?, "User config directory should exist"
  ensure
    Process.kill("TERM", pid)
  end
end