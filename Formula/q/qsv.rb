class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://ghfast.top/https://github.com/dathere/qsv/archive/refs/tags/12.0.0.tar.gz"
  sha256 "194be4a193dfb95c77005dcdb900f1e0b2e4c6cc0f2ee5c2a3fa6adc7ca962f9"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/dathere/qsv.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f33cc532fa144931ec5f44b105231eacb2cad72ddc6be2862f12a931c5e9a6a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c3b792bd7a54f328e92c7495e260b598b2f9cd42e69f65badbe67af1de58a06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cce7a27c311f7206a6c0eec07db3ee7febcb05c82eef567333aa64d935bc5f2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "bef49c25731ce040911fdcd721b4e3f7b11fb42171e8d428fd1fbc871f79d668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6da412dd93dedb549c0e08768c09e2955fd3af3733d9fc07142a43b3e67a5373"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f87664a87aa350aaf00763e0cc72706f71f8c08077b81d61de5b38330823ddf"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    # Use explicit CPU target instead of "native" to avoid brittle behavior
    # see discussion at https://github.com/briansmith/ring/discussions/2528#discussioncomment-13196576
    ENV.append_to_rustflags "-C target-cpu=apple-m1" if OS.mac? && Hardware::CPU.arm?

    system "cargo", "install", *std_cargo_args, "--features", "apply,lens,luau,feature_capable"
    bash_completion.install "contrib/completions/examples/qsv.bash" => "qsv"
    fish_completion.install "contrib/completions/examples/qsv.fish"
    zsh_completion.install "contrib/completions/examples/qsv.zsh" => "_qsv"
    pwsh_completion.install "contrib/completions/examples/qsv.ps1" => "qsv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,is_ascii,sum,min,max,range,sort_order,sortiness,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,n_negative,n_zero,n_positive,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,,,
    EOS
  end
end