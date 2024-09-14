class Marcli < Formula
  desc "Parse MARC (ISO 2709) files"
  homepage "https:github.comhectorcorreamarcli"
  url "https:github.comhectorcorreamarcliarchiverefstagsv1.1.0.tar.gz"
  sha256 "9278cc6b36974cbf0ddea2869b577ae41ad03e1753e596d50e221ccf0db700ff"
  license "MIT"
  head "https:github.comhectorcorreamarcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5b18317e5db12756a19aa7bd1f5ee62569e0c26048056f85efe654f4826d70a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63fd48b516c9d021c8ba4aec971382dd92c68fb2252b513b0a2439fbff3ad44f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1fbbc916e7202b5589388b2b5c956ea8bb47c3216e65b7b6767f006f4293ea7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1fbbc916e7202b5589388b2b5c956ea8bb47c3216e65b7b6767f006f4293ea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1fbbc916e7202b5589388b2b5c956ea8bb47c3216e65b7b6767f006f4293ea7"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e4735d20948c27011d2e6f70f8f71ba2d6b502eb5fa430a933f069153e753dc"
    sha256 cellar: :any_skip_relocation, ventura:        "32844aa6393c6be96fd00321d3fbe18a19118465f79d20a1a5679c2d911629b1"
    sha256 cellar: :any_skip_relocation, monterey:       "32844aa6393c6be96fd00321d3fbe18a19118465f79d20a1a5679c2d911629b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "32844aa6393c6be96fd00321d3fbe18a19118465f79d20a1a5679c2d911629b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae3a60b0df4513c2b475d17a2515a5f1c6357fa2b398e28546e988ff32941ddb"
  end

  depends_on "go" => :build

  resource "testdata" do
    url "https:raw.githubusercontent.comhectorcorreamarcli5434a2f85c6f03771f92ad9f0d5af5241f3385a6datatest_1a.mrc"
    sha256 "7359455ae04b1619f3879fe39eb22ad4187fb3550510f71cb4f27693f60cf386"
  end

  def install
    cd "cmdmarcli" do
      system "go", "build", *std_go_args
    end
  end

  test do
    resource("testdata").stage do
      assert_equal "=650  \\0$aCoal$xAnalysis.\r\n=650  \\0$aCoal$xSampling.\r\n\r\n",
      shell_output("#{bin}marcli -file test_1a.mrc -fields 650")
    end
  end
end