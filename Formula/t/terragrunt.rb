class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.57.0.tar.gz"
  sha256 "97986a10526c75e2fffa1feda72a0240c926e3aee537fe3d2122d5d4e6e37478"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "574b27099d543d69a2f0f133c94eda7fa993c53f8dd8cb06a8054f0e9fab4dcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cefa7cea93ec4f46c4a168b61aaac8c300ea670e695acc9c08b158b9c7bf3e39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96a42822ea9a3f1aea412dee1006fc15a86d5c3118d085de66bc1c7c5c5d2d6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "bff3d369b579dfc6aabe9cb7a71b78c97e3445d552e504a90ca1cf5b3301b652"
    sha256 cellar: :any_skip_relocation, ventura:        "e42e4c279ccb9b2b9e3eec7341aaaa2e52c5a98c50d0d67cdb64e09a64cca8fe"
    sha256 cellar: :any_skip_relocation, monterey:       "30d4ecd1e57a606bc82b0405570bc22faddca8f4f51a398ebc9af46f030d0715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16d517e7d28ec73f39e6232c351bcbbe76993f1ca87b9e784fd5567c08a61479"
  end

  depends_on "go" => :build

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