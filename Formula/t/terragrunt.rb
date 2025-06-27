class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.82.2.tar.gz"
  sha256 "d953552ecff91be5f9fec86672a8eaf380820e884f11c6c97116727c8ee3fa5b"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f31006c665e3e2e8b561f392bdf5e6e5c06eea521c58f04e6dee491d7cf67cad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f31006c665e3e2e8b561f392bdf5e6e5c06eea521c58f04e6dee491d7cf67cad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f31006c665e3e2e8b561f392bdf5e6e5c06eea521c58f04e6dee491d7cf67cad"
    sha256 cellar: :any_skip_relocation, sonoma:        "b598dcfc2129b0f84108251331012408a40bdeff30aecab32ba4678f559ad9a3"
    sha256 cellar: :any_skip_relocation, ventura:       "b598dcfc2129b0f84108251331012408a40bdeff30aecab32ba4678f559ad9a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52b78ebb531f7ad0f1f1ccb8908e5695f252831d3a9a5c8056b0d162c12a1c9a"
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