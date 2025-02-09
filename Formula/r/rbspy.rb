class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https:rbspy.github.io"
  url "https:github.comrbspyrbspyarchiverefstagsv0.30.0.tar.gz"
  sha256 "19497ae1dbffa2d794a58ebfb700445764d8eee3ee6a60f8e44e9e15b4f88a99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46b6d26a6d2417eea3eec130bbf7f6f4e97f8c1e7f22d9c1143ddc16bfa41f41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "562c0a9374c95214eab35e04dfa45ce450d981839cdd93ebe16a24685efeaa79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c48493f03fca4648ab6b2e5db8795d68f3c18fb82da8103e500394a1303089e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e85a3b85a2dd031c90a2f1d23ea41d6c1b76b64b1d2c0e740d5a2e741decbec"
    sha256 cellar: :any_skip_relocation, ventura:       "1ec1d94b3fa00634e7438ddc77bf1fddba58251d542ad7f006e50f866936b2eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa9ecd6192aade6d60c39d1ed7de4d40d78339a26dbce05cad5f364b3f5418d0"
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