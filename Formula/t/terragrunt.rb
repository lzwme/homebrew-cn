class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.77.5.tar.gz"
  sha256 "9b00c44aee29ad055a64b689ca50c6d5922183b369ee212dd637998f6c187793"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc2fc73c7916d36876e96f2d3947fe6fd99baeba53dd919916b6782a88e74c91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc2fc73c7916d36876e96f2d3947fe6fd99baeba53dd919916b6782a88e74c91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc2fc73c7916d36876e96f2d3947fe6fd99baeba53dd919916b6782a88e74c91"
    sha256 cellar: :any_skip_relocation, sonoma:        "413f6996066bfa15f3b7a1bfc7c1f8bc7ec0fe50adcd4cecfd4f3d39aa3c3f7c"
    sha256 cellar: :any_skip_relocation, ventura:       "413f6996066bfa15f3b7a1bfc7c1f8bc7ec0fe50adcd4cecfd4f3d39aa3c3f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ad3168df29e3d1f26f2d5785529c7dbc8db77ae2fc5eda9809a947210693bc"
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