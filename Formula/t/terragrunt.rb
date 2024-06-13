class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.59.2.tar.gz"
  sha256 "0fc1e4414441b1e86f036ac74ed6cf9d8ebbfe091a508267373ba25b805734a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41f7bf3269cf0870debd3e419099a40e2a3262774b9a62237f5454435159f8fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb9e4508602b5957bff0972932942dc238c4fbfd3b78610accbca544e91824b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75e25b0b64f6d8d00798793a5044f9a7ce1cb9a60e13c8d39cede236b4dba4ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "d09646cd03b9b556ad703c8cca11bcb87309fca5fe1d2f01bda33f917c03e600"
    sha256 cellar: :any_skip_relocation, ventura:        "e64596b136f64cfdbeb672f699f92597dfb863f5d73f439bb72bfd09a550196c"
    sha256 cellar: :any_skip_relocation, monterey:       "0c867696b4382594a45e81b882f714455680f8e358cefff6c6216b9239ebdb9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8df8cfd21e272682f055fa028d79906852b057cc35d4d1c00e8ccc86071c93d8"
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