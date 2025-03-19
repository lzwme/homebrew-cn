class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv2.0.6.tar.gz"
  sha256 "327a320103d87f0d66e181c17e0f883c09d056e91b7451c3b9296f819de22a36"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54afa2d805f3772b480ecf13d2389f95289614087c20d3ee226ff90f858873e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbe6b4442d0fe24a4bd9ee04617fd146b1ca92d02e5b889360e7a7fcf36be602"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be5eb3cb4f68498612e207c9780ce9f09fd6f484be811d8163c52071c20934a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5b7a424c172a70b4ec7784b4d45919def2edef13413deb8dce3cda92910334f"
    sha256 cellar: :any_skip_relocation, ventura:       "183ddab917716a499c6debd23da109ac2950913a8ad16d0f21b48efbb945d559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fefa3e819af1789107e4d08690b12feff6be0129727f7d814129b77a2e33a7d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end