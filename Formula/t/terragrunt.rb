class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.69.1.tar.gz"
  sha256 "62e58ceaf8a8b0d3a8aaa7a49f619edcc29c726d447d4cca1fbdfffb94a3182d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1dc7d910091aa8412f4dcac924d8989d4e910f3bf37fc8bb812c0087c475905"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1dc7d910091aa8412f4dcac924d8989d4e910f3bf37fc8bb812c0087c475905"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1dc7d910091aa8412f4dcac924d8989d4e910f3bf37fc8bb812c0087c475905"
    sha256 cellar: :any_skip_relocation, sonoma:        "921fba8a2866c03c6769a3f188ecd3f14a984b47fbb78a407f92e92a8e98d6cd"
    sha256 cellar: :any_skip_relocation, ventura:       "921fba8a2866c03c6769a3f188ecd3f14a984b47fbb78a407f92e92a8e98d6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bc2e14e8688cf82cefbf8c9f619c43e8f55c0481a2756e049fa6c87e56060b9"
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