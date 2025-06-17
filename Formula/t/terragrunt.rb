class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.81.7.tar.gz"
  sha256 "44702caebb7984e077b5126326956b0c11b100f0215661c34fa4c3ae88527f23"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ca63cd9cc1cc05930dc764a3b03599b8d5347a9b2f2537e4035dc65bedd19a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ca63cd9cc1cc05930dc764a3b03599b8d5347a9b2f2537e4035dc65bedd19a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ca63cd9cc1cc05930dc764a3b03599b8d5347a9b2f2537e4035dc65bedd19a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "024d629b99afe84eb48842d07bef7a9a2612ceb0a0dd7ec9ec9318db09d5ae04"
    sha256 cellar: :any_skip_relocation, ventura:       "024d629b99afe84eb48842d07bef7a9a2612ceb0a0dd7ec9ec9318db09d5ae04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd5310b5618e607a053a6201b6ea9a6ba5fffa9f4778409e4f9aee25500df57a"
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