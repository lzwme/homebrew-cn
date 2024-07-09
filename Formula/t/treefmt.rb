class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https:github.comnumtidetreefmt"
  url "https:github.comnumtidetreefmtarchiverefstagsv2.0.3.tar.gz"
  sha256 "c9ac73461907556d365df442aa7092a6500462d346699a40ef50fd22f24cb195"
  license "MIT"
  head "https:github.comnumtidetreefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a8be1afcd138bdd2ea197c1606e0fca57a2e343a597a2cb1b6b3bd2cbb01b01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37ef7061bfc3de110327119fe3d6edd3b5bc9a18f05073dd3783511f4b3f61a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46e52feaab7d5bc2e259e5bb4ba0a4598ca029a80972c79ccfd30fcf3e650230"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a951c391edacf675ec289dc1f9e6ed76bc8f7ae6d2f71595f389dd6dbc6bb2f"
    sha256 cellar: :any_skip_relocation, ventura:        "c84feb033189ac8103557e844811e8968cfcdfef8619bfaa82edb0c39351a11f"
    sha256 cellar: :any_skip_relocation, monterey:       "296e35b983ec2f67cd5f2678e5e93c6802a0319d91e6659941b22e49840c3e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "885fd2b04328299d4d142136b25315587fb925c6ad78722ae4033ceda0c0f670"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X git.numtide.comnumtidetreefmtbuild.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "error: could not find treefmt.toml", shell_output("#{bin}treefmt 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}treefmt --version")
  end
end