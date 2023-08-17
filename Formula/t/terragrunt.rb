class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.50.3.tar.gz"
  sha256 "13764e6d48a30ac06132079ce457061afa6bd6d4dabc3953c9b286be93598912"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d419178c690d42baa10fe2a8ec4906fd84cd6918e2782328f5637deee090ea3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8f317963c0316f7a52e12988080b70d2e41e238062035a4bbe6f3e6447296fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ef8199e46bc4207f5b1efb83c8bc21b1f38fb83166beab1424f6d1e7c9b3c17"
    sha256 cellar: :any_skip_relocation, ventura:        "b11186c139f3d7f36c6c330e747a89e983ad515b8ac1e2c016c97c69a005a232"
    sha256 cellar: :any_skip_relocation, monterey:       "a9799dd8775ed2dd464b65cfc0197ce47f099b17b06520010d8363049b7fcd6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "00410263f8cb308a0120f7ae95f92a70f51a362785ef13298b54ab63c8618120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d59539ae6ad205927cf24e39114b9301bcb7bcbb6022c5543d574089cbc58c3"
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