class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.87.0.tar.gz"
  sha256 "04d43027db9bdbf86c5f8bdf6c7624d6381b0cea26ec4042ccd5e9b063e3d9d2"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf966fa6bbb029a8a36dff5a7e7fb1965dca03d553258aae1f8fada0c77c6c3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf966fa6bbb029a8a36dff5a7e7fb1965dca03d553258aae1f8fada0c77c6c3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf966fa6bbb029a8a36dff5a7e7fb1965dca03d553258aae1f8fada0c77c6c3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fe4d3140877432f5cc20c598aa7778f5f57ce289c2a56ca071107eb488263d3"
    sha256 cellar: :any_skip_relocation, ventura:       "5fe4d3140877432f5cc20c598aa7778f5f57ce289c2a56ca071107eb488263d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa251f479851fb6db8811c2279e677354090bc7357222c4460eaebbfe8bf9ad6"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end