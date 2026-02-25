class TfSummarize < Formula
  desc "CLI to print the summary of the terraform plan"
  homepage "https://github.com/dineshba/tf-summarize"
  url "https://ghfast.top/https://github.com/dineshba/tf-summarize/archive/refs/tags/v0.3.19.tar.gz"
  sha256 "51f734fa9d76c8a8a40705ad9606134cb3626f907b225e90281b732cb8a2a05f"
  license "MIT"
  head "https://github.com/dineshba/tf-summarize.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d23074156cdec5e1b0560d0bdd30f37423cf6ac6b92ecf1f6567b1ebacd553f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d23074156cdec5e1b0560d0bdd30f37423cf6ac6b92ecf1f6567b1ebacd553f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d23074156cdec5e1b0560d0bdd30f37423cf6ac6b92ecf1f6567b1ebacd553f"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b50ab805fe60a99d6bc19b17d918776a5fbd50f138981c0d8f61c323c3c5c55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af79a23b1c33102bd0ec90ac230bfc01ad01c41fb24b657d90eff54239e0e628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd412601c856b1b3de489bd87814b9f1632468a4575a713c2345aa5a674a4fd8"
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