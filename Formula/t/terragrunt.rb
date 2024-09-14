class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.67.5.tar.gz"
  sha256 "246994c904bbc7ad365cd2b023ea3077bf1e1b14f57821df2d61a079bc75b9a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca5dc4c8c5e7d702012e09ea12a2e985c0edf5c120b425262df7c58738ec2c45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca5dc4c8c5e7d702012e09ea12a2e985c0edf5c120b425262df7c58738ec2c45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca5dc4c8c5e7d702012e09ea12a2e985c0edf5c120b425262df7c58738ec2c45"
    sha256 cellar: :any_skip_relocation, sonoma:        "df95351e89714ecaf77a3dff5bd38f8ba3ac403e100ffabb1b14810bc891aa48"
    sha256 cellar: :any_skip_relocation, ventura:       "df95351e89714ecaf77a3dff5bd38f8ba3ac403e100ffabb1b14810bc891aa48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2da43d5f6b62d7ffd3450c79c8e7b1954b911019bebfb119155ce7bb312452f6"
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