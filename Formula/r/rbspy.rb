class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://ghfast.top/https://github.com/rbspy/rbspy/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "b9e50943ea70a19bc24a0ac8ef9b938278cca64e0ad136375bbfa63072a0c702"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2de7ddf3c6b1ad0f3cb5c535562d1f95e082ac54c659fc6342f6e98c93f407d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d8eb4181448c9f141fb1017e6d9fcd26a5afa61a34ec6382bee59bffd1a1dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6226f050ec88c68601efefb13da05bf4d6f9d5485efb1e33d0df7e40c280197c"
    sha256 cellar: :any_skip_relocation, sonoma:        "b603a4a96bf800eea48cbc4562c7edbd9470d88e05ca0701daf9dcd7a21ca95b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca876ba47f708201945f440bd8fcc51a4aa43d420d1845dac9c45413fd4437bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "608f3d9f369ca600eaa2cb9faad476659defd70dcdefe2f45e73954e15616fb6"
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