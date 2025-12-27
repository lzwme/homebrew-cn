class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://ghfast.top/https://github.com/rbspy/rbspy/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "5867b0fc5edf0862c51692c820487aef8c640d2f51579c566facd841ead88ff1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af45ab9b16f6db47f94278bf64153bf0bb6231dcb8590b78e7462c2f297f8e2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4868e4a7a06bd8d84622d05c3fca0fd8aa576aaf71dcafb4c91fc90048de9559"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ccdc6e1eae546336349fe6caf26dff26d920d58ae88cc51ae046ce9237e9314"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce3ec38a6651f59828ee486e7ca25ba8e4a773c7cd882f83dd8a27669364c940"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f38e7c6e984f49538d459f5927ee3733a85fdca9caaf6ec22b9cd494ba257ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bce9fee6e51b23110a6fc67875c302feb3511aebb78ef7109bce86bf8b6070d9"
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