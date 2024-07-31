class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https:github.comjqnatividadqsv"
  url "https:github.comjqnatividadqsvarchiverefstags0.130.0.tar.gz"
  sha256 "d87d8420e79ec3482b2b9d0851938401309886ba7825e870883b9a397828c922"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.comjqnatividadqsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3352cb1595a316d1f0c40eba07e2e63be51f3a592c3aed1174aaa77fa118ee94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "795075a6a1c9e8ee1b586bb4f479cfed07ab6c50c751a09c67906b8ff5a50b55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df0bf382335aa0a56bb5169b73786c497ec587d650bdb01f2a9cb1da95d0f497"
    sha256 cellar: :any_skip_relocation, sonoma:         "8127f63a9cbf4302a103b61cdb3e44061efb3570ab5b03b40b55083f88b4db07"
    sha256 cellar: :any_skip_relocation, ventura:        "c871897cb5195c341b4796134aeaaea2bfcb41989cd84712071866f6a93a3566"
    sha256 cellar: :any_skip_relocation, monterey:       "56f89303061b516f0534a80acebd1232fa16a582243925e3f55bcf2d3a272fdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8373d5aa2e0bc21611e920fd077e507dbd5eb575f9624339457820f590c1d9b3"
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
      field,type,is_ascii,sum,min,max,range,min_length,max_length,mean,sem,stddev,variance,cv,nullcount,max_precision,sparsity
      first header,NULL,,,,,,,,,,,,,0,,
      second header,NULL,,,,,,,,,,,,,0,,
    EOS
  end
end