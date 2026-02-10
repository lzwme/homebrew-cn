class TfSummarize < Formula
  desc "CLI to print the summary of the terraform plan"
  homepage "https://github.com/dineshba/tf-summarize"
  url "https://ghfast.top/https://github.com/dineshba/tf-summarize/archive/refs/tags/v0.3.15.tar.gz"
  sha256 "54a65e0a2609d0e517531d3b152c6bfda4cb1c5f6793bd3a8d382f6bd2266b96"
  license "MIT"
  head "https://github.com/dineshba/tf-summarize.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "817e3dbb50ed6ef78be5f4bec2901d014099c4129db14447c09b6fc90daaf393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "817e3dbb50ed6ef78be5f4bec2901d014099c4129db14447c09b6fc90daaf393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "817e3dbb50ed6ef78be5f4bec2901d014099c4129db14447c09b6fc90daaf393"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac0cc1e876af84a47fcd69ae2c04f5376c7f0258fe5f2feef02e26deb24d6b54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87586383da71df3fefb6fa06368e5d49ed1b6552a79f04e499869dfeb0ac8a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00b1a07d1ecfec52ac850632e785136bcf079a47517df500ebaf5041a43d39e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    resource "tfplan.json" do
      url "https://ghfast.top/https://raw.githubusercontent.com/dineshba/tf-summarize/c447ded989b8e84b52d993e0b0e30139b5fb5818/example/tfplan.json"
      sha256 "ceca61c72c77b4400d4170e58abc0cafd3ad1d42d622fe8a5b06cdfba3273131"
    end

    assert_match version.to_s, shell_output("#{bin}/tf-summarize -v")

    testpath.install resource("tfplan.json")
    output = shell_output("#{bin}/tf-summarize -json-sum #{testpath}/tfplan.json")
    assert_match "7", JSON.parse(output)["changes"]["add"].to_s
  end
end