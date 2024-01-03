class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags0.120.0.tar.gz"
  sha256 "4f0d7a14ee75fa056be4932f4a9c044d0ccba2c7a404c1e3961a0d8de8f1962f"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3adf1daaf3fa37aa8dd2049c26a0d20297f34e6b4708541664f4b5afa5c402d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bda477128c4b784a771b4ca34e2921286463d6cafd3930b7f7e36af42042460"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc28914393092fdb1e653dda0f8d21ecd051e0c105dddc170762766eb2b37b7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a521f9d82f0e445b227aa30bfdcc74f3c36f679d5a1d1e80aeefd3ef45ebedbb"
    sha256 cellar: :any_skip_relocation, ventura:        "ffe87766f3329c8519b33f76e109a611afff72725cbf1dbe714cf2222486d8fb"
    sha256 cellar: :any_skip_relocation, monterey:       "859d3436cdb6a65389b274dcf2e6c59f3867fc89ba428888adbf1ba9ccdc99d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8cfa13411dac3851af576f921d69158d4811cc822fe1c70e9c2a41e14dfec9"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
  end

  test do
    (testpath"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,
      second header,NULL,,,,,,,,,,0,
    EOS
  end
end