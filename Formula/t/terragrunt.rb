class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/v0.50.6.tar.gz"
  sha256 "4483ae0b9e4229cec546f549f3705e4cfb7cab29c18bf248c9884ea8cb5761f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dae02572685781123a8ad7a920b016c82ce02c8be034bafed67da851549397ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ed5b694eafed4c4bd982827dc36041ccf96d645d1cc9947c9fa39ff2b8aa570"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bdcc537f0eec80ecfd06cc163c1f78f2e2fe0bef9abab909bd9ba26474a3749"
    sha256 cellar: :any_skip_relocation, ventura:        "bde0dc5f5c47c499ef326ef8cefc5877f8ec92ab253d4038cb848f05e5640076"
    sha256 cellar: :any_skip_relocation, monterey:       "5aff2031f606b7cb3b6fb12996289a3694114d179f6a12c9a655dc1b27b9fa3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1eaf5d3da24b9578761b0f7988a3490173dbdab9c39bf65929b8e8c6216d96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "083feff210e0c67f844703d9056564f6ca2e4ad449b44cb7a92e9932d0334e4b"
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