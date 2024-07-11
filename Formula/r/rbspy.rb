class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https:rbspy.github.io"
  url "https:github.comrbspyrbspyarchiverefstagsv0.23.0.tar.gz"
  sha256 "be8960ec406ee6131ab00a75ac19d40b218fe5594145413bfb64c0fb4fc3dc11"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1c6d6cc9357c8fc5509dec6ec82756a13902f31a04a27e8feb7635eccf34834"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c41f2cf33bc439afda8a97e830774737d851c7d599803b9f00e9e01349c9eed0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a24a071a45173439bdadf8cf612aac6aca7db6d8b11ea36a507009f9336f144"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4c379822e99e17a013b03d652d81335e52ded3d21e6ff06d8a512e29a99e810"
    sha256 cellar: :any_skip_relocation, ventura:        "baddbf5e5973737adb97d7d0d7253abf912fc83fdf72ecca263860ac66a30042"
    sha256 cellar: :any_skip_relocation, monterey:       "3353ba73448647db685a3f68da67f8c60d1c9916bb420c62ff06f723ddb20429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20d9ac6d7a74f2a010e6575529a63321c38f17e20c341dcfba57871d0e566cae"
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