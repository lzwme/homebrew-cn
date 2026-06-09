class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://ghfast.top/https://github.com/dathere/qsv/archive/refs/tags/21.0.0.tar.gz"
  sha256 "fe8a3fef2bb82e3d815af7aab6519eb92437983df2da4526190dc1631b45f82b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dc45e3327b64d2fe414a636d738bf160c79c0ec9b7fe83270fb085b33633f37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52134e3f58fe2c1d1c3707e3826c9e378ec3cc2edb74fc96c4b421e1e62eca50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "178fa4b8c3db7fe341c062db1db3f95604a7729bac34dbd2298a9c1a44323194"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eb5b4be034d926547f85c988d8d0639a0693a401ccb8c7c36e880c0e6acd3f9"
    sha256 cellar: :any,                 arm64_linux:   "a7a5eee9f8479f00216f875fbab30c821bec8666db1b78e30739bcd717151f22"
    sha256 cellar: :any,                 x86_64_linux:  "e029513ea70cf03431af1eea9172c16162f153f7f541d9db13981fd2a70d4bf3"
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

    features = %w[apply fetch foreach geocode lens luau to feature_capable]
    system "cargo", "install", *std_cargo_args(features:)

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