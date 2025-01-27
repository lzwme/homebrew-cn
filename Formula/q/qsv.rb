class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comdathereqsv"
  url "https:github.comdathereqsvarchiverefstags2.2.0.tar.gz"
  sha256 "1b2f6eaef2269815516ea8abc95292881877f19fb6007eac1e42f187d8ab350a"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comdathereqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "874ff0a240e86352ac849710ec20cf524df1e7a72743603620d38e4331c583fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c5854edcc5107cd8de2a55aba850a98f085463799d932b20d13a9ba2764ab55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6eb8b9461f24af3f1f71ee4358be99f29a7ecf22abdf7449936ebec993edda74"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc147f08473543adfe5226fc044ef831ccfe60219af750397628974170554f57"
    sha256 cellar: :any_skip_relocation, ventura:       "f2f614472c6464b5f6e7e2a2610368ab91b4939661a5b3ad261c5afa1e54a722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "540626ab4353fbf87ebb19171096db003b25a1749b0cf3a6e480ef076bb3c23b"
  end

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
    assert_equal <<~EOS, shell_output("#{bin}qsv stats test.csv")
      field,type,is_ascii,sum,min,max,range,sort_order,min_length,max_length,sum_length,avg_length,stddev_length,variance_length,cv_length,mean,sem,geometric_mean,harmonic_mean,stddev,variance,cv,nullcount,max_precision,sparsity,qsv__value
      first header,NULL,,,,,,,,,,,,,,,,,,,,,0,,,
      second header,NULL,,,,,,,,,,,,,,,,,,,,,0,,,
      qsv__rowcount,,,,,,,,,,,,,,,,,,,,,,,,,0
      qsv__columncount,,,,,,,,,,,,,,,,,,,,,,,,,2
      qsv__filesize_bytes,,,,,,,,,,,,,,,,,,,,,,,,,26
      qsv__fingerprint_hash,,,,,,,,,,,,,,,,,,,,,,,,,b818de06455146a422a60ade18c7e4ee5872089c79c32fd8a87a0f05e79564ed
    EOS
  end
end