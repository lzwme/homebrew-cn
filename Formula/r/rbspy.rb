class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https:rbspy.github.io"
  url "https:github.comrbspyrbspyarchiverefstagsv0.27.0.tar.gz"
  sha256 "ff5bf1c1b0cb012737bb7892a7f24f5030099b5633581d98a684f7837d06e3ce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb4fea45a5f2302fdb9012d3e93ce59ef36dced65ab966d263adbb5f8d3933ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "121fac33c3412bfc04dffabf2a0739a53e120cdf6cf76bc1660309c8cf44bdda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27cf7b8d354a27b430cc5901e8aec1b201cea750e7497affcf5a9465f611ff0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ed55329e082d39b535b742a37300e4afa13ba58aabe5fb23c01735ffee693a4"
    sha256 cellar: :any_skip_relocation, ventura:       "fc33b07671ceb096d9c4ad9ae927b9aad0da3bd3045ae83626229fd777d5cfd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9447d30ea69decb019e322e6e8c9edbb46d0023df51f36e69278e2e800289fb0"
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