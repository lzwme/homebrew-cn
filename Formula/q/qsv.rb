class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://ghfast.top/https://github.com/dathere/qsv/archive/refs/tags/6.0.0.tar.gz"
  sha256 "7e63eebc78aedf1b3cd1452b631a8255099feafebd5242bb700e2b6e1b311b0e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e690cd9294e4c17250b9a4877704e6029368fd2df387541e46ddedbd02dede5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f4e5f5951413a069cdf78e3da06ffca737a08e8d4c7420237da60cbf57b81dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f053b8599daec356f7e672829cf3b59ac5e0f59482bed10dbac8892c90329dca"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aed889c839985373e9d5c889fea8e90b3ddfe13a7568c513315b3f242edcd00"
    sha256 cellar: :any_skip_relocation, ventura:       "34f07782cf43050b9fc52bf6d5dc5ffea9702201dfd77194a73dfd87d64ad244"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93a474faa277544ee9c02bc1fd15b5d80d632d00275cedd55d498a55d3750d8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69e885b583e64f15fb9f4fd7fd8b392a8a3b6e5b0151cb302b3d8e5ae92e1afb"
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
    ENV["RUSTFLAGS"] = "-C target-cpu=apple-m1" if OS.mac? && Hardware::CPU.arm?

    system "cargo", "install", *std_cargo_args, "--features", "apply,lens,luau,feature_capable"
    bash_completion.install "contrib/completions/examples/qsv.bash" => "qsv"
    fish_completion.install "contrib/completions/examples/qsv.fish"
    zsh_completion.install "contrib/completions/examples/qsv.zsh" => "_qsv"
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