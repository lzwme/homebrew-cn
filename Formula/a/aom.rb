class Aom < Formula
  desc "Codec library for encoding and decoding AV1 video streams"
  homepage "https://aomedia.googlesource.com/aom"
  url "https://aomedia.googlesource.com/aom.git",
      tag:      "v3.15.1",
      revision: "44d0a57786f432d933ff64b653347c66f4d0fa1d"
  license "BSD-2-Clause"
  head "https://aomedia.googlesource.com/aom.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1b8cc8b3704e99e634b6bb3baff07ec508cd7a055fbf51cb4a951d8fb4b2065f"
    sha256 cellar: :any, arm64_tahoe:       "f78fc63421cf6d79eae934ffb0c0b8e671285cee6e4213c4fd08e5ff84b3d393"
    sha256 cellar: :any, arm64_sequoia:     "356ad2843b8ab1c11cc83043256cbcfeb659eb031215ecd116dfcbe2ea3f1d11"
    sha256 cellar: :any, arm64_linux:       "e6b3ee10a86d33cae4d6658a7cbfe3b164fedafe4cf279f80c14f84113cda99a"
    sha256 cellar: :any, x86_64_linux:      "ed7e7a71a73934b4d5e599fa0f7e61517c8ef6bae02626f438ca2f90fb389370"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libvmaf"

  on_intel do
    depends_on "nasm" => :build
  end

  allow_network_access! :test

  def install
    ENV.runtime_cpu_detection

    # TODO: report upstream
    # `snprintf` gets the whole buffer size as `cur` advances, aborting under `_FORTIFY_SOURCE`
    inreplace "common/webmenc.cc",
              "snprintf(cur, total_size,",
              "snprintf(cur, total_size - (cur - result),"

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_DOCS=OFF
      -DENABLE_EXAMPLES=ON
      -DENABLE_TESTDATA=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_TOOLS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCONFIG_TUNE_VMAF=1
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