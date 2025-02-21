class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.73.8.tar.gz"
  sha256 "86a85335bbcf081602660bac864a72f52a9a54cf4478c663b9fec60e6e68a1e9"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1df942bed705c560bd3e7e53270f24dac7c25fc3404cc7406f0d168fddb526c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1df942bed705c560bd3e7e53270f24dac7c25fc3404cc7406f0d168fddb526c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1df942bed705c560bd3e7e53270f24dac7c25fc3404cc7406f0d168fddb526c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "404ed8337266f686acd2951734b7cc470a6f4d5b7733d038229c262201560ffb"
    sha256 cellar: :any_skip_relocation, ventura:       "404ed8337266f686acd2951734b7cc470a6f4d5b7733d038229c262201560ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "152d26815ff4d2581f6b6b25a6838bdd58409c581b80dcaf55fa8068e7263644"
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