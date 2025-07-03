class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.82.4.tar.gz"
  sha256 "37e5f6c0683c41f3e30dc4cf636ae860911349b4749f9f43029e20657be58ae9"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "860d28922003d4f26c0e27498c061ca021cc1159f448aa3b05a1135ebbe3a9e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "860d28922003d4f26c0e27498c061ca021cc1159f448aa3b05a1135ebbe3a9e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "860d28922003d4f26c0e27498c061ca021cc1159f448aa3b05a1135ebbe3a9e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "696647fa61c28fb6d4dee80c08ba1ed808c8ff5e5a405f0982768b837e83ac08"
    sha256 cellar: :any_skip_relocation, ventura:       "696647fa61c28fb6d4dee80c08ba1ed808c8ff5e5a405f0982768b837e83ac08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35c79809621c24b7c35f35d09e5e002f897c7d7854213579d60335e284652e22"
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