class Tfautomv < Formula
  desc "Generate Terraform moved blocks automatically for painless refactoring"
  homepage "https:tfautomv.dev"
  url "https:github.combussertfautomvarchiverefstagsv0.7.0.tar.gz"
  sha256 "0a00bfb9b4a236640cc4ad0efd9d1982c14f93d5379a5adcd35b1691e0846044"
  license "Apache-2.0"
  head "https:github.combussertfautomv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15f822277c9415edce4e42e4cc8d26af85af55c4c3c673bb9a589023e416dd71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15f822277c9415edce4e42e4cc8d26af85af55c4c3c673bb9a589023e416dd71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15f822277c9415edce4e42e4cc8d26af85af55c4c3c673bb9a589023e416dd71"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ddabecdc49b7b4257f5674f0448deca4e522d314c006a1cdf144a6e0b24e3ab"
    sha256 cellar: :any_skip_relocation, ventura:       "7ddabecdc49b7b4257f5674f0448deca4e522d314c006a1cdf144a6e0b24e3ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d29d02610f03ccc17652c66df782b807f69d000b22a89a6c6e18e8b21356863"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    tofu = Formula["opentofu"].opt_bin"tofu"
    output = shell_output("#{bin}tfautomv --terraform-bin #{tofu} 2>&1", 1)
    assert_match "No configuration files", output

    assert_match version.to_s, shell_output("#{bin}tfautomv --version")
  end
end