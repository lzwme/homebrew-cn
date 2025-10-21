class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://ghfast.top/https://github.com/dathere/qsv/archive/refs/tags/8.1.0.tar.gz"
  sha256 "a28cb6f2b1c5200359c37d54f897d85af4b0309d96831c06953e5aab62a14688"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a613a8e0f17f2353c47d61cc5645bb5038d90386ec8a17b6c5a970e7b2fc294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b88ec696f8dce0003b2332dac7250ce751146e95777db12915a85df019d26e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d54feb64a30056f12c74da0809a8a055010eba97c843d8a8966c83a476a9fd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b3c5bac08ebe89581360b2e4c786fbcc340cac1db514b72a6ead725feadf696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e801994fe1427e7e75dfe0b34927c38675f13feada87347020349a637733161e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8a02535a86f226d0be2a94e31c68e4402805c06962a691f783cf84c7e92cd43"
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