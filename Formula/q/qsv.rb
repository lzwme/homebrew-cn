class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://ghfast.top/https://github.com/dathere/qsv/archive/refs/tags/16.0.0.tar.gz"
  sha256 "524b5a9b43da6f54d60a5f3063ba8b608fb28f23eb9155f3fec9fdb7ee2fe1c9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "773bbcf6ccbac17cbb24da7ba1d32095eadd0543a90ec8a729a988ad85bd4381"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7831fe89dfd7107b5a214282ad3bcce5682b7dae3dd4cf7e5481f56dc512457b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c8bfe9071a16d78caf8a0e6accc93f5bea807a45b951afadbd4cb87274c9b38"
    sha256 cellar: :any_skip_relocation, sonoma:        "9836c88de9f7dbf37c8cf32dc1b3e18529b840bd690e627cf878fb4661d674ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72e4e34a92ebdf30040a9a631784f01db6cf63f622ab6b533c6c73f034e6981c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c00bc2dab404eee0fc6c83d919291326cafd1b941e47f5254d84ac40446b213"
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