class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.71.5.tar.gz"
  sha256 "42e529b0f0de5f456edf523af87d1ea6e256e386f5a7d8294f7e20f94b6c82a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf40adae92ccb7850660d45384e7141599eb8b521f365f5622fb842f696072f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf40adae92ccb7850660d45384e7141599eb8b521f365f5622fb842f696072f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf40adae92ccb7850660d45384e7141599eb8b521f365f5622fb842f696072f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c453efdcfc047e6dbfe40cf4b51711aee2a18e69251d3fc79c7d3165e55d7417"
    sha256 cellar: :any_skip_relocation, ventura:       "c453efdcfc047e6dbfe40cf4b51711aee2a18e69251d3fc79c7d3165e55d7417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "328ec17c197af9e4c0d571c1411bc84112a17966fe92ecf29fadd909c0c5a3ba"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end