class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.69.9.tar.gz"
  sha256 "39b41a893a61476c39b8c1ec1da624027d6c7510a7bc33678599bd88cc7350dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed76946096706325d9b0b3c27571dfaeaba1bbb1a0abdae1f7573f88b2f2638a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed76946096706325d9b0b3c27571dfaeaba1bbb1a0abdae1f7573f88b2f2638a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed76946096706325d9b0b3c27571dfaeaba1bbb1a0abdae1f7573f88b2f2638a"
    sha256 cellar: :any_skip_relocation, sonoma:        "763202e18e3c455f477cea58936a6d855ca4cc291d26c9fc08328237c4bffaca"
    sha256 cellar: :any_skip_relocation, ventura:       "763202e18e3c455f477cea58936a6d855ca4cc291d26c9fc08328237c4bffaca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c830d25047b7beafe5af6ab8e72c456128bde0bf4a79c6be95cdb3e5bf679a3f"
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