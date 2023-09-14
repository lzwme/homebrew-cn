class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.50.16.tar.gz"
  sha256 "f489675b09021ac7b7f3b32c38649365e243a1df539a876520195fda8a7ee558"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b7f2b4c83f8b031143795141e19eb2eee03e2b79f9b3a644b67a46ac1f5dc83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "291e99e1a09ede3c4314a7c592ef852f4e08c06f067861f267c066d409e5ef5b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a47c6cd39070d99f95549cfd7aaca1428231d1b792ebb077c476201e6f0b150"
    sha256 cellar: :any_skip_relocation, ventura:        "4f6a00946297ff9c30660c6811cbf54380a1630eab03e82300ed6d0119ec38ec"
    sha256 cellar: :any_skip_relocation, monterey:       "f543d2080c390865e9b1f376df4663c6dc131eaff0891e54f7ed64ec5bdc43a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d706916e3e393cde7c334bb093cca0a2f7cafe7c6aa9d15bc056639e98c896be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4836779fae70c9db6e66333e879e80369ad5b888bfbd33350648a13ee40a751c"
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