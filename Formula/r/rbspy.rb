class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://ghfast.top/https://github.com/rbspy/rbspy/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "ca926a7315594c4d1686f910d59cae79c6d5a3a76d136a6725dc49f5a5818f8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40eb4c1f8daa1580f9b64c66b3576ca4fef66b69eb883d079a2287023fddca05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbf22daf0250d42519835b3d74f3559514e11fa16dee69810fa895a1bae4e1d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3302bb00e089678c3c5ad7f4920d38f73cef6544e356e68dece8ffb5615f6fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8b53ada48fd951fc3b47b34b8bd24fd70e349df50c769ae90f780be31361134"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "650a74b421ab357fb616648776fef55fe3845e97f08582211c3df73ea0ab8f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47aa6e47853dda3b48aaab4329d3c2958f4137e8288e3570ce99f0432f08ecfe"
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