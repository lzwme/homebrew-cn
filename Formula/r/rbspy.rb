class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://ghfast.top/https://github.com/rbspy/rbspy/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "7e93d1cb54bd6dcbde39f256188ca0a6a269fc8332a56b0c844e678c19636049"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86cc8a6820a083703566c53842c93f0a3bddb6a008d6182443ed7e266f792d49"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2da18c2f4a81c2095bde6088a956a8f17e9f599ed726dfacf96588a85a51a44e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6592dfdce0e9ab07f501ceb25f06d8d2c140779103568cdcaa27057d741821fc"
    sha256 cellar: :any,                 arm64_linux:       "51076a2f622d89f872160a91983020f918e0bbfc8541617ec39360404b1e5c9e"
    sha256 cellar: :any,                 x86_64_linux:      "70550fed6122828b26448c5827fbe57fbcb6e02f6480d7aa1da37b1cb342e8e7"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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

    (testpath/"recording.gz").write recording.delete("\n").unpack1("m")
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