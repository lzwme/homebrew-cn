class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.96.0.tar.gz"
  sha256 "d41e28aed4c829604ba8aebe66983cc00c4c901a5adf8c06c666b02499e89e0c"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fc4d53e6e22c7952011f85deb4d1017752d3b233dc6906f89fb4e4ba47ef657"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fc4d53e6e22c7952011f85deb4d1017752d3b233dc6906f89fb4e4ba47ef657"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fc4d53e6e22c7952011f85deb4d1017752d3b233dc6906f89fb4e4ba47ef657"
    sha256 cellar: :any_skip_relocation, sonoma:        "daf846c7451f2331a70f2887210830faa6959ff79a461e3a54218276a82ec078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba1c8895cd9dafde604ca378a7b36690a9573531fb6732d2775ff5c29991d318"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc845c56d595c4ad11b1025ea321d3c732de0164bba1ffe875d8fafa42be641"
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