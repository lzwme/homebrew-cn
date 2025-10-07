class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://ghfast.top/https://github.com/dathere/qsv/archive/refs/tags/8.0.0.tar.gz"
  sha256 "9f6700c5b8c8246970bb7b76d73f0714a113b707fecf8b6381dd1031c65aa300"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd3342c6cea0dd626c6c7771cdc1b8e7f6e7461640bec365146ea37c64c6eadf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7424c4de582fb1ec84f558d5ad60a016e1ab9f49f94be6640295321961469ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "816918489466ee54c9a14ca91081842df39b409cf5c7f6d22bd6d38d4468f131"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcaad6251ef91d24c001e7980dcbd73398e534e9e98e2042443015d471093645"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34f57576741f9769930da51f525ba7f657df77cee94660bbd6a3a743e334d621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b6b38d99cfb9a85659ce613b29fdde13cc5a90c04f85012cc5063ff569cef6a"
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