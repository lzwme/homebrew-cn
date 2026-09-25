class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://ghfast.top/https://github.com/rbspy/rbspy/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "2357adc3dcbe3a6eb2e0d8929fce8260f27f7840f02fbbaa6cd2db68d96c98dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5dd1f73c2acb95cf048b5892675382b68a0f2610909d6d97893eff6792e9c6d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "499b4ba9097e7208a9fdffd90267a62f7e7cd71b492bfdf831722330eafa0537"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "177ed70a33b8677e2561808ff12edf12fe3b370e6abbe70ff9786ab72c085c54"
    sha256 cellar: :any,                 arm64_linux:       "dacce7689a8ac3eee105567e112454b35084862a7e90cb22487f5b6e31c032a4"
    sha256 cellar: :any,                 x86_64_linux:      "4f05eea60d4ac090372c1610dc67a930719ac38779a05aad48e3aff51633a81e"
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