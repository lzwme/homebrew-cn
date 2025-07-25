class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://ghfast.top/https://github.com/rbspy/rbspy/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "2d0b0eabbe2ead6a2eb293fbb940a8779d04e573a157dddf24666008c13c9d82"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4eac6fb5288720ceb691bf33a9250550c315075f05be0a115c2be9d141fd50a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ab483eccecfc6a594171df490a48476eb12efb58c2b38c18be87cca3f415e5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "008fe9af7c0a43b2ce72e85d0f749e8e4d51bb094917d3861b818033510bfde3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7ef68a9f252f679c25a88b693044a2b2b4491f45b418c4cef399d3c1a285d51"
    sha256 cellar: :any_skip_relocation, ventura:       "f544a26ff16a03d94e6579e4f99611ed52ebd21fdfba9176c773a41769094061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57ce158ee7d35feae61bf38d2f7be91fcba5c088cd67ac4fae3cd97da3633ea0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "259a7b68ee7e866457e5e5da49c37769645f7e885b542583a4942c5e7093c2a9"
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