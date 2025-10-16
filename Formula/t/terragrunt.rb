class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.91.0.tar.gz"
  sha256 "ea66b8e77c503b5423267ac28a658b3c56b6bb32724d423b34ec4c360d044774"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95ab96dd3f7c5cb8e042d82cb7e5982a9ac14f1eae35fed78bdb6aa49a7d06d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95ab96dd3f7c5cb8e042d82cb7e5982a9ac14f1eae35fed78bdb6aa49a7d06d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95ab96dd3f7c5cb8e042d82cb7e5982a9ac14f1eae35fed78bdb6aa49a7d06d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff5d297211263db44e9a1e7b3eacb148fb548bcdfa6051f4cbf4eaafcd7a9773"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e664109cf83cab8678ac9423b251192a621966238d1d1260c82a9319228ae9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa1d70b074a414ac2110338f30acf4fd8bbcacb645111993f5572cf416b06d34"
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