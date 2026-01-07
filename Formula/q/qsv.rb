class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://ghfast.top/https://github.com/dathere/qsv/archive/refs/tags/13.0.0.tar.gz"
  sha256 "5da7ab158091534d1e5d7e9bfd37a6149720d378f59dbf425dedc67ca4acbf2f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e90d0dce8837f261d021154330dc09a5e357fbeca80ea2241b33d822925b2b31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7f4baf6943569b2661f5fac94e38de5f4fd602e77ca79817f531ce23f64cd11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ab7453ea4a14c48538087e3b8d1d1bd3f63e1db465e8b01e6487c030c9e571a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5ee303ebc4d76d3e63e7af920d515b5f5a38e4e1b7ee6e0d20b5f3ae5874d83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18635161429e7c11d81a758b71809a0cfc8e400d184b0950438f90ac40cdc6af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fdceb50f915f742c9a9b4c18b4fc81a50ddfe89a731b568a2085c0a2f84a2b2"
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