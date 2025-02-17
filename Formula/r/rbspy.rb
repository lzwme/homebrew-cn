class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https:rbspy.github.io"
  url "https:github.comrbspyrbspyarchiverefstagsv0.31.0.tar.gz"
  sha256 "a0cf0ef4dd4ecfd74849549c3e9ac159ac00f752175571199b2d1303dd3cacce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "220ae2acae037806c0b2e4172d00b32e5028dd259674bd39bc78c1d03cdc6362"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6371106e3f8c71fff4ee2abbcc26f131d657b91c981b23825582e2edbfbe146d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "089afcc06d305d1edea8add027e1ce5e982448c126fa81850b8ce2bc59116d9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "31dc9842b6f511e4bd499e2328af088556540cd2aae96e3c26e0b42974dbb1c5"
    sha256 cellar: :any_skip_relocation, ventura:       "00eea55d0cb422b76ef90425750cab779b75f142065cb22db71eaa680d4005d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c6b7dbf2e647cb8117eda7cc95aa6da84c7800b817d13e62ca8337bc0d9ef07"
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