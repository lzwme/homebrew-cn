class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.69.3.tar.gz"
  sha256 "08c4369d3d89c1e8355a4f6261af2555e297f17e0a683c676d8698c4c961c4b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82b546df15435f3187706477f8d0213016b3ee3bb63dd6d14b09776867600b0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82b546df15435f3187706477f8d0213016b3ee3bb63dd6d14b09776867600b0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82b546df15435f3187706477f8d0213016b3ee3bb63dd6d14b09776867600b0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0b1af88809e2f9853565e138c2e0062ca61e53c081d516ba9621d0264826d9b"
    sha256 cellar: :any_skip_relocation, ventura:       "b0b1af88809e2f9853565e138c2e0062ca61e53c081d516ba9621d0264826d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f04e8e38b3945bdeda072506809c6c190e86c2369986533225c5f3891bfbaf77"
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