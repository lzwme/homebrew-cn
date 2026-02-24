class TfSummarize < Formula
  desc "CLI to print the summary of the terraform plan"
  homepage "https://github.com/dineshba/tf-summarize"
  url "https://ghfast.top/https://github.com/dineshba/tf-summarize/archive/refs/tags/0.3.17.tar.gz"
  sha256 "a6d74613c227365eedcabe67c650af45bb62240b0e9fd6cd667bc70e16146780"
  license "MIT"
  head "https://github.com/dineshba/tf-summarize.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4cb6dcd258de7451e4aa65af5623611ebc247e2590eed6b9dc348b5a53c8664"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4cb6dcd258de7451e4aa65af5623611ebc247e2590eed6b9dc348b5a53c8664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4cb6dcd258de7451e4aa65af5623611ebc247e2590eed6b9dc348b5a53c8664"
    sha256 cellar: :any_skip_relocation, sonoma:        "16d4e51536a28b28896044bd4fdc699daa033e93f9ac18cfcf609f4fc11b4d7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a5cb09b62e743e7840f8bf8863f92bda4e2951de5711aa4ab56466f901ae7a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "503b4a395349479e50ffee56ef12d9c17051f835650cd54173f11acfe12f2661"
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