class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.77.12.tar.gz"
  sha256 "ede4f11f72419855960917d323d885996734881efa6e9ab1c50fb25749bf7180"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a40df88b07aa30ddc8f5ae839d069d334dc48e7970e82e970ebc44eeab04cbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a40df88b07aa30ddc8f5ae839d069d334dc48e7970e82e970ebc44eeab04cbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a40df88b07aa30ddc8f5ae839d069d334dc48e7970e82e970ebc44eeab04cbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba9df4283eda528582371e60e9cdf858f4d1c263183264bed844ba1e2ea3ecd1"
    sha256 cellar: :any_skip_relocation, ventura:       "ba9df4283eda528582371e60e9cdf858f4d1c263183264bed844ba1e2ea3ecd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78daa7ab9dee11302c6d6f8a31b6c06c0aafcf08b3245233150f9ae422aa42fd"
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