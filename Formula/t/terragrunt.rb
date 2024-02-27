class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.55.10.tar.gz"
  sha256 "fbf14cb884031de1d0a122da2e5e096aaa97ce4417b7f21d87377e6a3b23701f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67180fdefc8e1c3992e5b329ba60880ce33f6c55d283f27d5658ecca963fbf9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89b3afd0a1542eb14f15ceddc4db1834a7e5936545c131b34c1a3e65fe2680a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d32d0916bd1017cf436fce812e23fda538d3c1959ca556c325667a19e84891ae"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e4a1d4693b114fe277b6195b0929a29dc10875c2b9dc089b75376ee895e771e"
    sha256 cellar: :any_skip_relocation, ventura:        "5dbe54f6d02a39d71d8382a8ecdd1cc0ea46421d9e8f0f016d692fdbd8758e9f"
    sha256 cellar: :any_skip_relocation, monterey:       "aae14627da035f0feedf8c858ed151b85eb2cadcf180b95189632df03e98e3ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d38d27bdf606ea9e29634f321f850f260444489f946117ac65c2827c5b41372f"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end