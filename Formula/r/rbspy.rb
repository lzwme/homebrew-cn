class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https:rbspy.github.io"
  url "https:github.comrbspyrbspyarchiverefstagsv0.28.0.tar.gz"
  sha256 "78faa83617b9057274a1ee9f94ee4fdafc78f984b526541f8a2d1bffadbe5f81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ebb13c4bfbab63ff8edf32c8b52933108fa811a762d426b535b52d3628633e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28816c6712941c51da96213b92d423aa18f7fd59b0c2ebd90d6578657488a798"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60224507bf26838eccd7fa804d01cfc3eb0c905bd5ade31e88c8ce841f7fb8a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "166c252baaed55f022d2ef969648659cba8f4e531703b6f115b98b12e02b9423"
    sha256 cellar: :any_skip_relocation, ventura:       "4dbc519ef4ec282f7e310c9eeb37233ce54053168950bd62ded2c9229ea6b464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76063e05098ca13127a123524b69e136dcae13f4408c8ad494aa68e10e09c347"
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