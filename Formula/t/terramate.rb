class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.6.1.tar.gz"
  sha256 "0f9f212ac200f836857e3bdd0ebb1f865f3e471cc13bbb51afe4030081255668"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a274c4461d6eaea2d94663193edc9ff8618a8e1cebbe8e9ffa03f422ce20e989"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c20a8aa1ebd5b370b88a18b39aca5c96b0e56e9692531510e15b77844ab33e47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b51dc60b96129fc0f0240de2848bbb36d4c84e3c99a040d05c0fc95b4a057257"
    sha256 cellar: :any_skip_relocation, sonoma:         "e406cb4779ba367bae3edb1ff21d74d43aa96f42d848fe5f273b8650e131f85f"
    sha256 cellar: :any_skip_relocation, ventura:        "58b982bf52ea97bba8786ab6c32e607918cba1ddd6c873be37be60890d1f1a74"
    sha256 cellar: :any_skip_relocation, monterey:       "47d32d5f358380281fb79839c7c588d8341b98eec1991a0addc069de16c292c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e67ee56482c545b10c7ed4d73397515ced89e7d53e912bd90d5d5d49e9d45022"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end