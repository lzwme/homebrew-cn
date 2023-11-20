class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.118.0.tar.gz"
  sha256 "b312fef7fc9798e9077a56618c56fa25aec3714e197217bef49a1dc7a52bbb7f"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "647f85da5e995b9305f42217e11dd4b7633d5b4febe8275c7c06b5342099b066"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e43e43fe3e852417e9b6646b798abf6b9e6c0d98fbef83f4376b3b4e9efe1a01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f7a93d12088b0b43ca76c82f85c7c1eeff505861b9cb214f7cf2b80598f0699"
    sha256 cellar: :any_skip_relocation, sonoma:         "f45c22096c2b913eea99c3711a7fa9384a8aa116b725a530bcc3eb5d69fe98fb"
    sha256 cellar: :any_skip_relocation, ventura:        "2ad8516841b6a82a8bf343e7bc0557ae3256b00d14f7db8ad04ec5e57431db7b"
    sha256 cellar: :any_skip_relocation, monterey:       "cdc5a52b20f6ac29a619c30781f7bb44608049b5284e7a40cda6f6dfcf5a739c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9fdcbd4e7e3d92b0bfa0d12bdb9e38f86b7f465dc5b737b95c9c6b524f2ea03"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,
      second header,NULL,,,,,,,,,,0,
    EOS
  end
end