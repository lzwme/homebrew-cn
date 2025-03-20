class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.76.2.tar.gz"
  sha256 "dcf7812df212dcd2a81c72f8271519129f2d5cfd5f5529339b46c52dfe63449c"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c10c3dfa687f9ad7ce40420cda64c13d36bb24e38c6ac537282eec80f01cbba3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c10c3dfa687f9ad7ce40420cda64c13d36bb24e38c6ac537282eec80f01cbba3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c10c3dfa687f9ad7ce40420cda64c13d36bb24e38c6ac537282eec80f01cbba3"
    sha256 cellar: :any_skip_relocation, sonoma:        "87da2abb5abdb15879882890195bfe1b13225260546cb2669cb26e1e84858486"
    sha256 cellar: :any_skip_relocation, ventura:       "87da2abb5abdb15879882890195bfe1b13225260546cb2669cb26e1e84858486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31c0be7c6b9a3424330abfc7db447c1ffcda035bb3fa7205a435e40554e29093"
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