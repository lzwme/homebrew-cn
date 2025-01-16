class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.72.1.tar.gz"
  sha256 "e845c01f9393392a506d7e852e6e9539217525d6416a6d7e5bd1e8b187a4a347"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94f56ef07e732785771de1dd2847b0e12e3ca9b7d6a6bddb783071663a177b4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94f56ef07e732785771de1dd2847b0e12e3ca9b7d6a6bddb783071663a177b4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94f56ef07e732785771de1dd2847b0e12e3ca9b7d6a6bddb783071663a177b4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "390e1175cbe3879889c31de4b69967b8cc3b23c5aba5067ddd91d7dc3d7febd1"
    sha256 cellar: :any_skip_relocation, ventura:       "390e1175cbe3879889c31de4b69967b8cc3b23c5aba5067ddd91d7dc3d7febd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7abe37c71c4a2899c90a9eb5f80734ee9a6aea9ce4dea3e00a702028a72b282c"
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