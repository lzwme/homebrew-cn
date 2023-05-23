class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://ghproxy.com/https://github.com/jqnatividad/qsv/archive/refs/tags/0.104.0.tar.gz"
  sha256 "a3501323e3f168523d1b922f2c5a282b209d14dab8a87d1ea674b4972b3a3163"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc02af3b6aec3d129edd369311b2fbcaefc4c0a2644b776403a84c5485ebc782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee11d04cde13c37abb29343a599a7c48c0c1128bda6bbed08c4aea7811866a1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72c2dcd2d6b64587d4c1246ae04f8993f94933564e5937f392c761ea0787834e"
    sha256 cellar: :any_skip_relocation, ventura:        "90ed1118055ffcf6b9bbf990e74162a657efda1f78d2f23d11cba248b42558b7"
    sha256 cellar: :any_skip_relocation, monterey:       "e11e5b33096309f79ec9dc176c0a1fe749075bf4d2582dc4b410262213c96916"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5fd16a0b6ea0861a10be4e39f5dcb15df451aa20b06e829024d409cf115d706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2b10a00550c127f11eaa1c76c54616a0db6fcd03c05cc933c4c1dcf67d56a96"
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