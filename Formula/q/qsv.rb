class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://ghfast.top/https://github.com/dathere/qsv/archive/refs/tags/7.0.1.tar.gz"
  sha256 "f6dc3ca7dc227a3ff325464c8861cdc3f1e3d051857bed3882ba041804af4822"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7ec32a026abe5c6b2d760a9eff8c98776f1251b45f00297e826071fbbbbd952"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db8eeed3c604ed69840b4f88371e7974ab33835d9eb18e456e4fb26b3eeddeb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f47b698b31271b8bd893109fd2a27d5074f6000a3abca0846516533213c8a938"
    sha256 cellar: :any_skip_relocation, sonoma:        "181729b0f4afe6bfcbb6dd437f598a097d310645608b89807b2f0e27a580f927"
    sha256 cellar: :any_skip_relocation, ventura:       "fcd52cd1d3484327b8a42c2b5cb490af504ba242d03c8e9a2df8ea5585cfa5f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63f4284a691c67b8fb281e08d9065020960b69a048d5af7bce1ee903cab314df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238b4e7be5554afaf00ffd22b8259bc597fa11a61c82a0e900d9be631e3bcc3a"
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
      field,type,is_ascii,sum,min,max,range,sort_order,sortiness,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,
    EOS
  end
end