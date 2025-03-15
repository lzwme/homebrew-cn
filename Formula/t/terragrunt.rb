class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.75.10.tar.gz"
  sha256 "6ff2ad96d57b5541428f44940d1e1a61c2fbf0db38647f66524c9c29b4fb1806"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87dd0968479cbf8657ac1788c125e496a61346425c8d35f63637c5e2c032f281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87dd0968479cbf8657ac1788c125e496a61346425c8d35f63637c5e2c032f281"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87dd0968479cbf8657ac1788c125e496a61346425c8d35f63637c5e2c032f281"
    sha256 cellar: :any_skip_relocation, sonoma:        "feb0c4023f4257cb03194f57631b2384d3b1171ab6ad304e793ea72d83b6a362"
    sha256 cellar: :any_skip_relocation, ventura:       "feb0c4023f4257cb03194f57631b2384d3b1171ab6ad304e793ea72d83b6a362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21eb5fe5fe6c3c98a9d9829351892c925802da957ea63e5076e399b9d2e0949b"
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