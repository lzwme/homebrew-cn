class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://ghfast.top/https://github.com/rbspy/rbspy/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "bc7f7dad3f6427de1635ba119b25a5b68a2088b6f22d5168db6e217507b95863"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3513eb2db0a40f932a97822a598f4f354279262399b013cf908a96f81812d03b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1ed97289ef6c649caf93d27b186dcfe1da926d5fcd8fd3bd77f29471f30a4a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "274abd687f6dbe53903fc20ad45e369365b4ca027af4c97f62e4c91a18931690"
    sha256 cellar: :any_skip_relocation, sonoma:        "884dd0c16b4449277af615de1b1426983e6b7a71cf12556ce8805412e82da120"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6504169c90142c0571add55a302f9c4ad8661c0a3e24ab7e7f3179c6e04d337a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45d8819def944ab8d63adcd98686cc4122844f2e75578ca05d670ebf3aae7f71"
  end

  depends_on "rust" => :build

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

    (testpath/"recording.gz").write Base64.decode64(recording.delete("\n"))
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