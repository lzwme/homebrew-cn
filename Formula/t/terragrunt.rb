class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.58.10.tar.gz"
  sha256 "53e3f7d407d12773e8990b18041dcd40bdd760db37acf06223f62b808b5d3fe9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c66f5b8a4b7a50c573e9a80e54522fe7ce82edc879ddb6f2ef3ef061ad18619d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d5746cad6d4df2a6b109f46810b61d83eb4faf17c4310a1212704d67a437b04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42149cd6c015c6e3e3d3c7d0d68619764ec1c3a68945f77f2f53a68619ca9b40"
    sha256 cellar: :any_skip_relocation, sonoma:         "a99bc4a02a15c5b88f37bbcd848f88350631a71e70a3bf4fcd81ce6e79cf9e88"
    sha256 cellar: :any_skip_relocation, ventura:        "bfb63cb60a3e9216e7ade433aa4e468aa785949d6d962e85655d60814f70e409"
    sha256 cellar: :any_skip_relocation, monterey:       "e58672386e32604b1370d83d7ec5c4b6e6eae8389f69b9410779628ed5443b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6c76db0e170c5071770bea41ce628ddbb7fa7bfeacac42a22e637a76d9062d7"
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