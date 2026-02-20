class Kalign < Formula
  desc "Fast multiple sequence alignment program for biological sequences"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://ghfast.top/https://github.com/TimoLassmann/kalign/archive/refs/tags/v3.4.9.tar.gz"
  sha256 "d13b1b44b0215b67990cef60a92e14acc4664b480730f18f39ef116773a58d33"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d71de68f07c21e649985f010cef7502dd29b256700ded8efc908aa564f3b608"
    sha256 cellar: :any,                 arm64_sequoia: "668f2d470103b6aa249f1133630e554fdfe07a0afd268dae82eea4332ff9185e"
    sha256 cellar: :any,                 arm64_sonoma:  "0ac67fb6153ed206da0482c45964252ee16265ec714d623428aa87dd246f997a"
    sha256 cellar: :any,                 sonoma:        "9e6198fa0dac0f702eb876485821097b110264d67a4837f0877196d0c1d5421b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e32bc0eaf913eb0271cd7c115b968b2759b4bb509120836e58765226cc53eedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5c8d89f32862749a8f4085514e16aab7a3a52fe67c092dec6e15e66fd2eed06"
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    args = %w[
      -DENABLE_AVX=OFF
      -DENABLE_AVX2=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    input = ">1\nA\n>2\nA"
    (testpath/"test.fa").write(input)
    output = shell_output("#{bin}/kalign test.fa")
    assert_match input, output
  end
end