class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://ghfast.top/https://github.com/rbspy/rbspy/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "ef72983efdf95af47caf293a414f81f0e31d8a4e968ba33bfc45d3bdf0cc9d14"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e0483473c6c6397b17654791be6cfb8a144c507cb52d6558d9a5fb764e602fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f18eb65e75bcb9b331bef6db1d811472076f20308a3a5062e3961c84daca397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b543e4f5bf2e7fd4b338c68ea100082256f3450221507e42198a15d42e698698"
    sha256 cellar: :any_skip_relocation, sonoma:        "30eded994a72c872bd115ea9c96ca8dc0f9365b2e7fe13c42e5876ae6304d689"
    sha256 cellar: :any,                 arm64_linux:   "d2c93ef9c1f3fe6737c2fec56783d9adea889f24abb37f28c736684f72a11c7e"
    sha256 cellar: :any,                 x86_64_linux:  "86875d760da9e788183c38a18594165443155d12f9ccd97a2b06d09db475ed99"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    recording = <<~EOS
      H4sICDJNbmAAA3JlcG9ydAC9ks1OwzAQhO88RbUnkKzGqfPTRIi34FRV1to11MKxLdtphaq8O
      w5QVEEPnHrd2ZlPu5ogon+nq7sTRBy8UTxgUtCXlBIIs8YPKkTtLPRAl9WSAYGYMCSe9JAXs0
      /JyKO2UnHlndxnc1O2bcfWrCJg0bpfct2UrOsopdOUsSmgzDmbU16dAyEapfxiIxcvo5Upk7c
      ZGZTBpA+Ke0w5Au5H+2bd0T5kDUV0ZkxnzY7GEDDaKuugpxP5SUbEK1Hfd/vgXgMOyyD+RkLx
      HPMXChHUsfj8SnHNdWayC6YQ4ibM9oIppbwJsywvoI8Davt0Gy6btgS83uWzq1XTEkj7oHDH5
      0lVreuqrlmTC/yPitZXK1rSlrbNV0U/ACePNHUiAwAA
    EOS

    (testpath/"recording.gz").write Base64.decode64(recording.delete("\n"))
    system bin/"rbspy", "report", "-f", "summary", "-i", "recording.gz",
                        "-o", "result"

    expected_result = <<~EOS
      % self  % total  name
      100.00   100.00  sleep [c function] - (unknown):0
        0.00   100.00  ccc - sample_program.rb:11
        0.00   100.00  bbb - sample_program.rb:7
        0.00   100.00  aaa - sample_program.rb:3
        0.00   100.00  <main> - sample_program.rb:13
    EOS
    assert_equal File.read("result"), expected_result
  end
end