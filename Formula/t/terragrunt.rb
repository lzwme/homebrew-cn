class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.72.4.tar.gz"
  sha256 "f9f2649a58bca6ef2d332b9301d3779825186bb9fb99b754ee049304353c7000"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bea72b83c46a34b22a3aabb9f3edf42cc73903daddfa8231dfb2867a794adbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bea72b83c46a34b22a3aabb9f3edf42cc73903daddfa8231dfb2867a794adbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bea72b83c46a34b22a3aabb9f3edf42cc73903daddfa8231dfb2867a794adbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "95e5afd282ead28e18e1d7ec039b8ef4aa2324cdd0d57da08e444bd38c196a37"
    sha256 cellar: :any_skip_relocation, ventura:       "95e5afd282ead28e18e1d7ec039b8ef4aa2324cdd0d57da08e444bd38c196a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "331ae14166d231d5627fa47ade66a7a3d744bf50ee9b79f6050ab4a2cc3fa6bd"
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