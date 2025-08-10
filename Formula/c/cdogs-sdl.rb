class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://ghfast.top/https://github.com/cxong/cdogs-sdl/archive/refs/tags/2.3.1.tar.gz"
  sha256 "0a9bd151e33504a2323b3f962720f0d9091645bc378a7b20059e6cd20ccd1270"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "29cae0e86f62a41ed00096243a0ec3743844a510c3caabd9bf2720d54c2f4682"
    sha256 arm64_sonoma:  "ff029027df05a16a261d0961893c63de1148ed613b16548263a33c13f18fbd3e"
    sha256 arm64_ventura: "ddbe4bfde11a74cfa6c70f6d3b844af04fe83e0043bc24405e39623558bf8808"
    sha256 sonoma:        "55ff534d6f98220775a3a4495a445862119d9bad5d71524a8c3e57e8550201e3"
    sha256 ventura:       "6d85bbf02513d82b7b1e58dae63fa5dc247cf5075b1ff52479652617102e201c"
    sha256 arm64_linux:   "356a398fc7f2d22c1110b9a66b633aa3f4e6289408f99f0055b551a14aa6716d"
    sha256 x86_64_linux:  "01363a74f86c05e13d60ba788fa91cd13007b2b349dbbba13801f24504e29253"
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
    system "cmake", "-S", ".", "-B", "build",
                    "-DCDOGS_DATA_DIR=#{pkgshare}/",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    *std_cmake_args
    system "cmake", "--build", "build"

    bin.install %w[build/src/cdogs-sdl build/src/cdogs-sdl-editor]
    pkgshare.install %w[data dogfights graphics missions music sounds]
    doc.install Dir["doc/*"]
  end

  test do
    pid = spawn bin/"cdogs-sdl"

    max_sleep_time = 90
    time_slept = 0
    time_slept += sleep(5) while !(testpath/".config/cdogs-sdl").exist? && time_slept < max_sleep_time

    assert_path_exists testpath/".config/cdogs-sdl"
  ensure
    Process.kill("TERM", pid)
  end
end