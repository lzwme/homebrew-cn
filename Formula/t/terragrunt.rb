class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.55.8.tar.gz"
  sha256 "c95ead3751829618b26a3fd61d25f24a63d67f5d71a4597a8bf1733987362142"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e274df71bb6b8a3af0017cb154e365c717e06bc83d27da7af1aa943921f6f050"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "888d39b63c02ebd25fdce377c157e5fcd1318fd433636e3ef5375b09ef633998"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beb866de836d0d7be8f302412e8f124bfdb9031c4073b1a7d1ba47802eb074bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f13a6cedcb55b2853520d80d6fe026accf9890e2340c0f538c8be7f20f2f6ed3"
    sha256 cellar: :any_skip_relocation, ventura:        "cfcaeca6acac4e6234ba3808c8db745659f1336395df1cbe4f936ea22713911e"
    sha256 cellar: :any_skip_relocation, monterey:       "9610928cefd3c50a4190f5175d362ad3e6c7810a6c138e2386eb04515c47eca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae2a4354478d2a8c3bf2264bd074a4b722b1b5cd4a05ab04bf58354fbaea6e47"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end