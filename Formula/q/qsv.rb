class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.115.0.tar.gz"
  sha256 "6a689e67af0cec5dab25aab7d13fe06e75dde0d7d73b73e13c0ce6faa85df89e"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af3711284b5653e6ee9104f18f69d910e76f706135ef5a7c73a6e1ec831fe334"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18f4482c10109ae693c4c947ed40233d918f5a63ca12fff475be345d0f6dadaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "978df3a0a3dfedf0da021c52588391f2189533d98b9b11991ed700b79c72635c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f75ea47e54e60375686463244e5622fb048fbe0c99e255a2ea13a0c2bc51bdd"
    sha256 cellar: :any_skip_relocation, ventura:        "3505a009a6326bf8a24da9936c40cb3349ff14e58289a56efd85afe5a88b2b45"
    sha256 cellar: :any_skip_relocation, monterey:       "7e39729d095c98ccdedf24e76ee7c98e6cc8658db3f190c51629cd99b6baa536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5357a022bf37998d30e9e7dda84d33594ddb40c89ee760f4d6419abd853d2c4"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,
      second header,NULL,,,,,,,,,,0,
    EOS
  end
end