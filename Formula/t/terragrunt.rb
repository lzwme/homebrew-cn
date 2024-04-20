class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.57.5.tar.gz"
  sha256 "e9c83c5cd0dc0411f5dbc2f12f6846e954c4a2728146cd321de7f79b75546b04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35e6b756b3385ced2156dd068486c1f16afc7ec960bea5b88ffc30274e04fa72"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6210576bb8c8f297b67ea70a8336de21a45844f100390611db04209e4a0f1592"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e881d2e45dc51c6e5115505614e125488bcace247b95337b4f35fd3dc195896b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea81113f6a3dbe3bb1175764760a8821ac9860d035a1f7faadb81834b260af5c"
    sha256 cellar: :any_skip_relocation, ventura:        "f35e23e333786925230d3bf124a271cc7a8c189d63437bccf8a4e46b57856d67"
    sha256 cellar: :any_skip_relocation, monterey:       "2aa114c74e4b8a1dcd3981ac2f0647fbe690a46b5e08f0324843ee9c86258324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8167e39d7932d619c5afeea579c4fbbb69427fb69472db6f50e5406b48c2c84"
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