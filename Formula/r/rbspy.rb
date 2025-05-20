class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https:rbspy.github.io"
  url "https:github.comrbspyrbspyarchiverefstagsv0.34.0.tar.gz"
  sha256 "dc2eceb963ef9a5687de89fef38c28ebd4dab857ed7dfc20b51602f45c6d76ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00152ed6d763a51b1fc8d72b8228792ca12b93e877faef4ec6fb18989f357240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c95fc5fab0859c4b82996c17a07c5a1c0f5d25faeff942c82b008adee4a6ae78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d816f45c7e933f681c916836823a89d07cde4fceca93395b40a3174580d808e"
    sha256 cellar: :any_skip_relocation, sonoma:        "069e7caf1452681ac1bd10688391f200c89ece6621574793c0da6d751a726671"
    sha256 cellar: :any_skip_relocation, ventura:       "bd2d548da50209c4c893279c6d1e8c2111d17c489eb346632f970fa66ab00efc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79fe778925ad97df49253a044b0b48db48432255ec4dea512c9cb8b4a9fa232a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "515273aac17fca97e203d9a6dbce05e61c80c92deca9a7a077e844289cf0cc37"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    recording = <<~EOS
      H4sICDJNbmAAA3JlcG9ydAC9ks1OwzAQhO88RbUnkKzGqfPTRIi34FRV1to11MKxLdtphaq8O
      w5QVEEPnHrd2ZlPu5ogon+nq7sTRBy8UTxgUtCXlBIIs8YPKkTtLPRAl9WSAYGYMCSe9JAXs0
      JyKO2UnHlndxnc1O2bcfWrCJg0bpfct2UrOsopdOUsSmgzDmbU16dAyEapfxiIxcvo5Upk7c
      ZGZTBpA+Ke0w5Au5H+2bd0T5kDUV0ZkxnzY7GEDDaKuugpxP5SUbEK1HfdvgXgMOyyD+RkLx
      HPMXChHUsfj8SnHNdWayC6YQ4ibM9oIppbwJsywvoI8Davt0Gy6btgS83uWzq1XTEkj7oHDH5
      0lVreuqrlmTCyPitZXK1rSlrbNV0UACePNHUiAwAA
    EOS

    (testpath"recording.gz").write Base64.decode64(recording.delete("\n"))
    system bin"rbspy", "report", "-f", "summary", "-i", "recording.gz",
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