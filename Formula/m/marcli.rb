class Marcli < Formula
  desc "Parse MARC (ISO 2709) files"
  homepage "https://github.com/hectorcorrea/marcli"
  url "https://ghfast.top/https://github.com/hectorcorrea/marcli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "7ee0ea5e0edd73e1ac7155bf9d3579f20818384ba1dc12b5a87f869b00a1ca69"
  license "MIT"
  head "https://github.com/hectorcorrea/marcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8195322c8bfb3058cee9538c3c3a9c46cdb42a6d8a8d96f93bb634ade82869f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8195322c8bfb3058cee9538c3c3a9c46cdb42a6d8a8d96f93bb634ade82869f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8195322c8bfb3058cee9538c3c3a9c46cdb42a6d8a8d96f93bb634ade82869f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "297dd93fe14afefbde8e9e79a1eecb57c11559aaa4a09fdbbfd7e601b74271d3"
    sha256 cellar: :any_skip_relocation, ventura:       "297dd93fe14afefbde8e9e79a1eecb57c11559aaa4a09fdbbfd7e601b74271d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cc36463a6cb016a3709b04141c833b1fe867e95d2ed42036492788b5d8d39e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6c80b649b3202e6abd273807d6d49beca9f696a9de0aa6e1bd9e61b29f805d7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/marcli"
  end

  test do
    resource "testdata" do
      url "https://ghfast.top/https://raw.githubusercontent.com/hectorcorrea/marcli/5434a2f85c6f03771f92ad9f0d5af5241f3385a6/data/test_1a.mrc"
      sha256 "7359455ae04b1619f3879fe39eb22ad4187fb3550510f71cb4f27693f60cf386"
    end

    resource("testdata").stage do
      assert_equal "=650  \\0$aCoal$xAnalysis.\n=650  \\0$aCoal$xSampling.\n\n",
      shell_output("#{bin}/marcli -file test_1a.mrc -fields 650")
    end
  end
end