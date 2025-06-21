class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.81.10.tar.gz"
  sha256 "54813762ae2fe8668b8b90c4436a1d3761e5f2faddeef0ef32273d938399dc74"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ef1e90e583ec694224b3b779670d25c9d54588d3fea693603e6b50744446e3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ef1e90e583ec694224b3b779670d25c9d54588d3fea693603e6b50744446e3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ef1e90e583ec694224b3b779670d25c9d54588d3fea693603e6b50744446e3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a67f9f47d620dee8ed67dc57c3e5e352e927a223a51bd7ca18d7bd8bcfaea3c4"
    sha256 cellar: :any_skip_relocation, ventura:       "a67f9f47d620dee8ed67dc57c3e5e352e927a223a51bd7ca18d7bd8bcfaea3c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bfd8e2c0919e8863c87e608dc4deffb26d1423711354f1263a30760abceb51f"
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