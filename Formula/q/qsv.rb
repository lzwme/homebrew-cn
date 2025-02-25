class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:qsv.dathere.com"
  url "https:github.comdathereqsvarchiverefstags3.1.1.tar.gz"
  sha256 "a533e35c4c2a4145e9d94fec76f5cc0ddf4b9f650286145172096e677fce6af5"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comdathereqsv.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1962e7a8de6164d69c6d1afdceb5aa8db167bc739677523ed2accce37f3f9c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13f138ca701756370c670724a89f2ec5f0ac881bd66fcbde398e52eeb9cf90dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f470fb011781a80c214f195220653f34fe28d560ddd94bbc5a4f59050a7db2ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd76c6b28d4f8409fae0923d7d5040a1657e56c441274255c5c8af627b88dd96"
    sha256 cellar: :any_skip_relocation, ventura:       "8f69c6293a2bdb33965aa8322986713e43bd62c72565a97dafd3645370fce1f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15a5c92a4344ef00894a05a0faa0bcf30c93f870b48680b3c20b878c62d24fea"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
    bash_completion.install "contribcompletionsexamplesqsv.bash" => "qsv"
    fish_completion.install "contribcompletionsexamplesqsv.fish"
    zsh_completion.install "contribcompletionsexamplesqsv.zsh" => "_qsv"
  end

  test do
    (testpath"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}qsv stats --dataset-stats test.csv")
      field,type,is_ascii,sum,min,max,range,sort_order,sortiness,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,max_precision,sparsity,qsv__value
      first header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,,0,,,
      qsv__rowcount,,,,,,,,,,,,,,,,,,,,,,,,,,0
      qsv__columncount,,,,,,,,,,,,,,,,,,,,,,,,,,2
      qsv__filesize_bytes,,,,,,,,,,,,,,,,,,,,,,,,,,26
      qsv__fingerprint_hash,,,,,,,,,,,,,,,,,,,,,,,,,,589aa48c29e0a4abf207a0ff266da0903608c1281478acd75457c8f8ccea455a
    EOS
  end
end