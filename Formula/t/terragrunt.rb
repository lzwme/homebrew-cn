class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.51.8.tar.gz"
  sha256 "c19a65c9efa8d739cb9f65cc8ea3f5decea198739c727e1cc4a73a183683fd43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a95636128853b3211639f4ba3778739208ad94dd104ad54d0621740bea90924"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f58e860110106f830c7e4a86577c42e9e4dfd55c916f48ca69acc21c6c96e6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cba79ab58fd66314831d6de857981656059dfce4a043b3d626a8b5c01824226"
    sha256 cellar: :any_skip_relocation, sonoma:         "da7471f4a9337c8100b7cf38fb95edb103ac6b0db8443fb0ea3352817a601a8d"
    sha256 cellar: :any_skip_relocation, ventura:        "9965ac50e1906c94d49d0850f2c9d4a9752b7637593063ea999019fd7322b5db"
    sha256 cellar: :any_skip_relocation, monterey:       "4bac06d1899461fa547a14631adb783702df423f3697147127b1c460a6b8f72e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a08fad2bd5f467d35952635bb6e991295eba142f44fbb0d1ac3af480a5693ba0"
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