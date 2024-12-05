class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.69.7.tar.gz"
  sha256 "a0ec55baceec788db53273545e4d2025de7cc0774056676fe3f6d21d19751b5f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eb9d84b78bea5dbde83c12ba2da4c87c32f4cbb2741cfd3c44e11876f5af7d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eb9d84b78bea5dbde83c12ba2da4c87c32f4cbb2741cfd3c44e11876f5af7d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4eb9d84b78bea5dbde83c12ba2da4c87c32f4cbb2741cfd3c44e11876f5af7d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "02e9477777b536cd11ed97ca782eb3cc0853fcdad8b2b4f6adca6b9e07ee924b"
    sha256 cellar: :any_skip_relocation, ventura:       "02e9477777b536cd11ed97ca782eb3cc0853fcdad8b2b4f6adca6b9e07ee924b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "054ff321ef9589fa09f3ac5bbd60ef1daa1666e5ea86662e4ba52f1026d89339"
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