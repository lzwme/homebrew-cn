class Rbspy < Formula
  desc "Sampling profiler for Ruby"
  homepage "https://rbspy.github.io/"
  url "https://ghfast.top/https://github.com/rbspy/rbspy/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "0c2736776ed302ef73e25053032b9db30c3855edfb7fb7f06d86e98dd2bf87fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d4a8e5262f86e40c4217386e50fd743af03df12a96b79095adbcc4f3d5ee411"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d2e1096eb3348e0f64e99c4b576545aea4f3666485dac4319a84fc9b4793405"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11215665231d03605dfd7aa7c2d0f10fd096cb66d97cb93e4717c964eba08d8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d266b00ff9691cebb100056e7e65c6ac3355f0523eb681d984e8c7b56dada7fe"
    sha256 cellar: :any_skip_relocation, ventura:       "2fefa7ff65836fa0c73ed561eb741bc5612779df8c2be40dd8480c2439423e40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f2cb24ad0629772b2b70576634b06b132aba58aa091c56e9a15ffa6a0026ffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40f1233a8c385182552d9124df19b002f1a218e54f49c40a0f8f07335a313f9d"
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