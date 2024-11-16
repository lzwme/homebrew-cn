class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.14.tar.gz"
  sha256 "10fc14bad8338bc07259dc0e9cb0778477119fe2b1e8fcc8399e94f19c5868fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6609eafb27cfc5e6cdd306758313e419679cf1935cd614b0a7a5622c63abf33d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6609eafb27cfc5e6cdd306758313e419679cf1935cd614b0a7a5622c63abf33d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6609eafb27cfc5e6cdd306758313e419679cf1935cd614b0a7a5622c63abf33d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ed790d8149bd57f456a2fa359ca4252e8db25b94e5573ddb6aaced5c6d67d06"
    sha256 cellar: :any_skip_relocation, ventura:       "4ed790d8149bd57f456a2fa359ca4252e8db25b94e5573ddb6aaced5c6d67d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3da51ae29766f5fdb4b5ea451ec726e8e14f3274bad2bf4a32237641d8eb0b2d"
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