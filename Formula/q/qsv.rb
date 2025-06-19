class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:qsv.dathere.com"
  url "https:github.comdathereqsvarchiverefstags5.1.0.tar.gz"
  sha256 "9bed0898cce8de237a0a04f8d28947720dbb6d0b2919cf297007a1a57569dfd2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "243f7f28836c546e018a36ea0788eb1d58268d93a67b0f613cc7608baddb61b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee4ea68fc70b1425682668d71bcb8e7c95c11730c6c35b80c9fffc5d4e4df742"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2073e3fced0e3c6eac7d9a82eaa8826e9351f957154a6518c0597472c7a3776b"
    sha256 cellar: :any_skip_relocation, sonoma:        "002b6176e87d61dbdfcc366d5c73448e354b4f21f82d4a9c72c550ab207b757e"
    sha256 cellar: :any_skip_relocation, ventura:       "a85210ffe5b8ea93d2f7eb46b97d3e87f03e6e881e08f3c717592a57aaa7c717"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84939af77a2217dc553e0aed84018d7795759f7e469d05e62ed38b899a35394e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d294a8766c948fad6a9bed4581616729bd6d73ede3bfd772e04b7191a42daa01"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    # Use explicit CPU target instead of "native" to avoid brittle behavior
    # see discussion at https:github.combriansmithringdiscussions2528#discussioncomment-13196576
    ENV["RUSTFLAGS"] = "-C target-cpu=apple-m1" if OS.mac? && Hardware::CPU.arm?

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