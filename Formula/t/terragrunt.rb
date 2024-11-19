class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.15.tar.gz"
  sha256 "25ee7b8af090d6dbac3502502678733dc175020daf57fde5d2fde6033c7d13b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65c989a95be1d6abcaa4e1a44c18e581642e00edaf29f0e73d3348b1e44ba447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65c989a95be1d6abcaa4e1a44c18e581642e00edaf29f0e73d3348b1e44ba447"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65c989a95be1d6abcaa4e1a44c18e581642e00edaf29f0e73d3348b1e44ba447"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf0ccd0467b8cf468c627e56f0a334897c4815b97255a89da7048766110c090b"
    sha256 cellar: :any_skip_relocation, ventura:       "bf0ccd0467b8cf468c627e56f0a334897c4815b97255a89da7048766110c090b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "793a24f99ef13f691d7e30e02d630921a5b36c7a2ff9e1424310b37cf45f5000"
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