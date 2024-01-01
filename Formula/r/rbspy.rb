class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https:rbspy.github.io"
  url "https:github.comrbspyrbspyarchiverefstagsv0.18.1.tar.gz"
  sha256 "d8cc08107e47c8d9a025d8ff13cb0fec6b7d6eacbf3519b086b692a902a2e64a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad2563bd11f9c02817c372a5e1a925bdaad2dc38ab592de752e6e934b3bc28ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc6517a59c8236a14a789c8d4fc67c53e615d7b0b689734e2ca9bc405777809e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d60f3f7fdc771068d3a040b6434d58d25b8381456727f35073a43bf3ce235b92"
    sha256 cellar: :any_skip_relocation, sonoma:         "af4817f72454a59c6ec8b9e56d33652ee0bb92a05297628dab4a3aee98fd9f6f"
    sha256 cellar: :any_skip_relocation, ventura:        "f16045a94a8d174632985ff7a44dee974b92c23510f2407ebcb4304aedb8e702"
    sha256 cellar: :any_skip_relocation, monterey:       "440073a927be55cee9779e243aa51b157f71bd370998dad26b103306a509d7c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fefe036abdc729ee7ba2af0bab2dca0d4e478fcf5d0efc3f0d39bf08e61d9f84"
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