class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://qsv.dathere.com/"
  url "https://ghfast.top/https://github.com/dathere/qsv/archive/refs/tags/16.1.0.tar.gz"
  sha256 "f2edbf740677f2d80da55b73ee4fa620521702d6bc35a559f93dafa9b1bc58ab"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb48228632918823f611655d06780fd974784336450bf469c0f090d145e34289"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5be130b3d9d16ca0d770bad911ab9f944474d4c0a51cf18b614d2cc8a5e08f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5212460a14e2df219bdb13b4df168bfae4249a357e67a45eac9b03a74d1c4e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc3ff552eaf7a4bba202bc662d60bcbac44a5fff5726ccbecc3605e1c31434f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1afc3c4fe4a429e3e0d38c895681dfc4d7ce59905603aff191d73ce2f54a3a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e406c26735785262c1670a9c9d67bd00003343947ed804b0c40a3fb64a4f871c"
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