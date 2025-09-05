class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.13.0",
      revision: "d9c115ce0951324dee243041ef810e27202de20f"
  license "BSD-2-Clause"
  head "https://aomedia.googlesource.com/aom.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "427504d997f853980118b8ed424b4db98675ed2bb99e7bcfbaad19c0f7f66a96"
    sha256 cellar: :any,                 arm64_sonoma:  "6fae48561a064c46bc5669965ca8757ff94715272b45ab099d06631d09882c08"
    sha256 cellar: :any,                 arm64_ventura: "fd1c7f50e8e7efc46aa8da77be8a4c362e59366d853e15848eb671e39d909e3c"
    sha256 cellar: :any,                 sonoma:        "f9f915656e7f65bb6fd1a8b572299c1771c9f67cee97748e4548ce2ac88e192e"
    sha256 cellar: :any,                 ventura:       "5287444c273e2b91e0adbc96d279d12f0d477e2a20e7072c791d33fa6227f80a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fde6b3c5482f9db2a8cf3e73be010d092761cf4c47f9ea5b2763900d55972ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0aec62ba89d39da7bde4c3fc233c204b71b9eda609b720feafb60cf8400d9817"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "jpeg-xl"
  depends_on "libvmaf"

  on_intel do
    depends_on "yasm" => :build
  end

  def install
    ENV.runtime_cpu_detection

    args = [
      "-DCMAKE_INSTALL_RPATH=#{rpath}",
      "-DENABLE_DOCS=off",
      "-DENABLE_EXAMPLES=on",
      "-DENABLE_TESTDATA=off",
      "-DENABLE_TESTS=off",
      "-DENABLE_TOOLS=off",
      "-DBUILD_SHARED_LIBS=on",
      "-DCONFIG_TUNE_VMAF=1",
    ]

    system "cmake", "-S", ".", "-B", "brewbuild", *args, *std_cmake_args
    system "cmake", "--build", "brewbuild"
    system "cmake", "--install", "brewbuild"
  end

  test do
    resource "homebrew-bus_qcif_15fps.y4m" do
      url "https://media.xiph.org/video/derf/y4m/bus_qcif_15fps.y4m"
      sha256 "868fc3446d37d0c6959a48b68906486bd64788b2e795f0e29613cbb1fa73480e"
    end

    testpath.install resource("homebrew-bus_qcif_15fps.y4m")

    system bin/"aomenc", "--webm",
                         "--tile-columns=2",
                         "--tile-rows=2",
                         "--cpu-used=8",
                         "--output=bus_qcif_15fps.webm",
                         "bus_qcif_15fps.y4m"

    system bin/"aomdec", "--output=bus_qcif_15fps_decode.y4m",
                         "bus_qcif_15fps.webm"
  end
end