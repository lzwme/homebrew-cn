class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://ghfast.top/https://github.com/rbspy/rbspy/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "a2598561dc67c174e5a653100d8cccd21525094674c602f7394cdffc81f7e3ed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7da00ba941f6798792f8511aef8056d3dc30c7f9f8825619d48c3f079cd1000"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "916a1ca5743a37d78791cd9926a1cb2dd494f109016e690a6ee22ddf47f8a93f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b86c3b719c01242afa558bf65818c3c20f16609eb4f3891e4aa326fba8e82db2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ee8970967254db73849790f6ed6cc653dcba48c674cd873ade51b911c8abbfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d64559c6a1adecce7aa910bc97bfa741aadd13a337ce42fedc20db29e043d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6711a6ebaa3fc27fb1eb0eda195992920175c90e6c1599264152a02ce7d1b3f"
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