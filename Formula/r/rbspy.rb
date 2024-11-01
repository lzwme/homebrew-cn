class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https:rbspy.github.io"
  url "https:github.comrbspyrbspyarchiverefstagsv0.26.0.tar.gz"
  sha256 "30f34212f34037a8652c0aea1d26c3bd9ac65a8bb75f2960868a2b2117a4784d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "361460fd3718d9bea92404397166a2c3cfa52c6302872cee3daf0d80aeb5f1ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb3ad7f82d16f268b4504433810f93078cdae9286c97b6253336bd719f29b1e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83f90e9a95969fa04f1d3474fc366fa08eb51bd152ca8507e7598ae888bd7e83"
    sha256 cellar: :any_skip_relocation, sonoma:        "15d17bbe1d9c0695a2c84ffabc3e9e660e94eeea0c71cd0f776ce9fadee5d66f"
    sha256 cellar: :any_skip_relocation, ventura:       "504a614f1f66248059823436c93793d77519150a79789c4549bf4a0976fc373f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bfd35b6cc84bd70ede5ea4751a334d83bb7122b37052beb197a5ad9d33116c2"
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