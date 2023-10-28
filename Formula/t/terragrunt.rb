class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "a8279dc1edc03954c0dbbf986bc5063845fa8a40a3da7b957d3b8bfbac8f5f55"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aacbe31259bf2e09a746ab1bf4b09cca55fee6359ebdf13d25852269b6c61b0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a84a60955d5ddf09d63d02258d99ea31cba07e860c5956391694469630426e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6db56ad71340c7e1e988acbc71496b8133fb9dc8c5a009d8ae0c30288bc1c06f"
    sha256 cellar: :any_skip_relocation, sonoma:         "937a2ca95908963c1e6369fa647b597a76ad90666c45755e664cdf620549c63b"
    sha256 cellar: :any_skip_relocation, ventura:        "685d4c2c7c7dd1aea4b630e991b82c2dbd550228e887778870214c8637e8c2b7"
    sha256 cellar: :any_skip_relocation, monterey:       "e4d042541a3e66e427f54acbd431b6a157d9d66d543d8e77921647a7b7ad25ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb9aeff5ef626c0be60e09d9c9eeb1dda710959b31a839f875e580e1de897f1"
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