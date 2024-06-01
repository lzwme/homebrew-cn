class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https:rbspy.github.io"
  url "https:github.comrbspyrbspyarchiverefstagsv0.21.0.tar.gz"
  sha256 "9767731c61f1686db69f226a4ec826c7e2f3d98466dfc6f00e0409c3dd8544ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b24e2752f249b908bad710a05c7228b1d3769f1e6e225a98988516050f6bb47a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d4bff2dd2a161f82f263d0665c59a1161ac661e9ca1dbb9525a8bf689d2730b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51c701056ecfb6592d7772be076d7ab4c1d1b4ed7a278a639296dc3023972a18"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed432d520cc7a9016c6ac7600761c7d0d054f36ddccf4203f39e59cd572c75a0"
    sha256 cellar: :any_skip_relocation, ventura:        "fa16b4d5221dc0a0f9f5bccad872c3c99c6d21efb64b6dd89c549c909b632df7"
    sha256 cellar: :any_skip_relocation, monterey:       "583aaf71ece4442d9e486778825447e7b328f82f6c1e6c45c5a6ddb67b423e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a127708e10b647038bd111802d33c1ee8f37b41fe7a926e8ec49fbcfd59d4e2d"
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