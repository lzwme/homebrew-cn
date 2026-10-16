class CdogsSdl < Formula
  desc "Classic overhead run-and-gun game"
  homepage "https://cxong.github.io/cdogs-sdl/"
  url "https://ghfast.top/https://github.com/cxong/cdogs-sdl/archive/refs/tags/2.4.0.tar.gz"
  sha256 "0fde6aaf07db2156e5d4c8e448f0ddb4608ed3b92b89aae1e2c87b20866e451c"
  license "GPL-2.0-or-later"
  head "https://github.com/cxong/cdogs-sdl.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "dff76b16434ead5e0adebf824341004f7e6a69930152a5a3238929b601c1485e"
    sha256 arm64_tahoe:       "ac02662d502c57e6e87beb2dc63120c9ebaa4b279bbf399f9c4837f9e1e85dec"
    sha256 arm64_sequoia:     "5886fcaae95ae725cc3ec544ac63b891861774a0543fcc164611437f5a662f35"
    sha256 arm64_linux:       "0899a6b9e98c7e4add872b4e28b9198c4ecafe622890a8faf10dee71a841eafd"
    sha256 x86_64_linux:      "a279da5a90a930604f6aff7290404095a441b73292f320ec5f24bd3db0e15f51"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "sdl2-compat"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"

  uses_from_macos "python"

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "mesa"
  end

  deny_network_access!

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