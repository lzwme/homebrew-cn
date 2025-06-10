class TerraformModuleVersions < Formula
  desc "CLI that checks Terraform code for module updates"
  homepage "https:github.comkeilerkonzeptterraform-module-versions"
  url "https:github.comkeilerkonzeptterraform-module-versionsarchiverefstagsv3.3.11.tar.gz"
  sha256 "f18b908c48b942de8327a958ae56242bd39d6530f7bd9d7f862dc2fa89c115e5"
  license "MIT"
  head "https:github.comkeilerkonzeptterraform-module-versions.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30efd3f974b11b2a2485bd27ff1d84e022df9e9186436600d3ff3f1d1cf6c050"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30efd3f974b11b2a2485bd27ff1d84e022df9e9186436600d3ff3f1d1cf6c050"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30efd3f974b11b2a2485bd27ff1d84e022df9e9186436600d3ff3f1d1cf6c050"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4457aa6a640b738a5c3ac987822c98ff9011c9bb9a2db105ae8bd39b9d0e57c"
    sha256 cellar: :any_skip_relocation, ventura:       "f4457aa6a640b738a5c3ac987822c98ff9011c9bb9a2db105ae8bd39b9d0e57c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d22cd7b027f23b40571fcb3f2828270a6ad31c52f6342fd75bbbb63dd5984f35"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terraform-module-versions version")

    assert_match "TYPE", shell_output("#{bin}terraform-module-versions list")
    assert_match "UPDATE?", shell_output("#{bin}terraform-module-versions check")
  end
end