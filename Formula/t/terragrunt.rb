class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "bcd36e28aa7b4f3ce1b797398e2669f40f62a057dfb5692828bef03805b4d949"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "326eecf035e25a757ba4751ca1b2ffa98efec6643cd1fc76309625e541b4cce1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81f220a18c0195ea1e15f23089d4eb4d717af3a5ff0c83532b8f961f2b22f009"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0341ec02f5da8456e639011ce0c563c32071d6c3347e69d9e902dece7df2dbe9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa1a8a2518be6d07543364df3159804e1c9a39da6b6d51ca81e7d99cb19dc4d7"
    sha256 cellar: :any_skip_relocation, ventura:        "3085587161f6da7aed6d6c25c693d53ad334a22c05407159ce3863bc116c66d9"
    sha256 cellar: :any_skip_relocation, monterey:       "bba7eb94d57210473c2fab40ada4512f8df0073a1a172f389d80723a471a7267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "485fdc21a176a3bad2e5964171b0649d7ca42dd9879c513eebde2a67006db9bf"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end