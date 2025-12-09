class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://ghfast.top/https://github.com/dathere/qsv/archive/refs/tags/11.0.2.tar.gz"
  sha256 "239838d64ed956be64004beb38d382af3282d2b76e19c6de15b669292be00ca2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3ebe96c9e5d4297c0f931be29fa27625ee56ec9c19550b8e908b83e3332ca5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22decbb51534105643e54cd9387863370933d0a7e54311ccac043de1ade72cd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9552d55793622929ee00a4c8698713e7523604fa0b49d567e5fa3f7e937268d"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e034dbf661af68a90b0894f98de2c9537c3d2280a11570a2e5cd0c5a0ac7bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "392b2dd3b8c42881ca5abd99f64d9ab685ebd32959906cbc3c56c7e16a41cef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4326aa8c1a8189569e5a4deaa81a08d01a8cf8cd938b2fdf87334e204ca4abd"
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