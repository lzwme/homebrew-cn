class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.14.tar.gz"
  sha256 "b7c2d446f63ad2ca68617d9b9305a10b9a43a33c3ef42a63ba018961dc4e4eca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "738e4751abe2477f4e3a558b8724e60366679a5d9a37675196ccc60159235d5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "738e4751abe2477f4e3a558b8724e60366679a5d9a37675196ccc60159235d5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "738e4751abe2477f4e3a558b8724e60366679a5d9a37675196ccc60159235d5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "76313a9a33ba6138f9dab44ce4528eb0a0ae62bca1af02a1357e0e0ba4b28140"
    sha256 cellar: :any_skip_relocation, ventura:       "76313a9a33ba6138f9dab44ce4528eb0a0ae62bca1af02a1357e0e0ba4b28140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdfdb5bb1e7bf0463760a61550d25c25ab04ba7004954297002b8d929de9d96a"
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