class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.77.10.tar.gz"
  sha256 "22f6e74289a7041070e6e287bd86018e19d987c477a5c007590a15efc3375141"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1c2c0ae92e207bf9623c2df962aa514796fee2c9018a80afd4227bc17613bdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1c2c0ae92e207bf9623c2df962aa514796fee2c9018a80afd4227bc17613bdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1c2c0ae92e207bf9623c2df962aa514796fee2c9018a80afd4227bc17613bdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "96fb1c23bbd8360815d0ea9f28be929b5a65b3ffba17f97f900b05255f3cce70"
    sha256 cellar: :any_skip_relocation, ventura:       "96fb1c23bbd8360815d0ea9f28be929b5a65b3ffba17f97f900b05255f3cce70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5d9e4f23dca2a0ab09233e75e2338369e0410b96b6932b0ca11d45a5a773386"
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