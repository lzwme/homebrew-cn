class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.72.0.tar.gz"
  sha256 "48cd5f64fadd16c98b321d16e1cd10c03d531f07ca2f57b293eaeefe70fa8712"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6997759688bbb67f1ccaa0148b697336460c21c168a10e8bec212dac255c961d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6997759688bbb67f1ccaa0148b697336460c21c168a10e8bec212dac255c961d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6997759688bbb67f1ccaa0148b697336460c21c168a10e8bec212dac255c961d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb779f24cd8659efaf32457a33f19315fd8ee6415e1934f73ebcc89ac13b0b89"
    sha256 cellar: :any_skip_relocation, ventura:       "cb779f24cd8659efaf32457a33f19315fd8ee6415e1934f73ebcc89ac13b0b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c64c16b7bfa8d5d5777f909d8402700c77edb5db489cd9f571dedc945337ba3e"
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