class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "c7e38284f4a612889d95f5740050fbbc372c8886e33706ff432b3391ef137e42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34fb96bbf90436a865e8f8d362f38ae887973480189deaa95b40cc3ee7807a7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "555bde6ea3f2d77ccf7a2d45297d87fa3430e28929f3b85f190dae8e1bac24f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97ba3c377b570b4e062a44107b296ff97eec6f41dd5be18de16cd4732d4d0b31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "013980606bf9a47bd53a70a07c54b09754530543bb56d52c8f2bfffd580f231e"
    sha256 cellar: :any_skip_relocation, sonoma:         "624930c65fdcef5274b29033b357823a4a332a41b0f563dcf3d6add7a9b467b3"
    sha256 cellar: :any_skip_relocation, ventura:        "a374e23743af203503d95874996642810c9debbb5ebc20a0f990f073c9e8d006"
    sha256 cellar: :any_skip_relocation, monterey:       "86c874e7d9015323c6668485293d49a7578d3274f2a47c0154f38a9dfe3715b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "34ab3117ab4b11a7139e858979bdce7ac0cbca09e2096302f95ebe78e9b0a1ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fc901c77f8875950464106aff21df9e9d2eaec55718fb401c66c5df144c9984"
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