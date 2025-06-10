class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.81.1.tar.gz"
  sha256 "28cdde44c2deb42cfd029e866454b0081952b6d871ebecf0a87956e4416947b8"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f1e58f47ede6d3693f961aaa5a45373caefa5401ff4179c07938cdb9d6c2bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f1e58f47ede6d3693f961aaa5a45373caefa5401ff4179c07938cdb9d6c2bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6f1e58f47ede6d3693f961aaa5a45373caefa5401ff4179c07938cdb9d6c2bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1ecc20cd74bbf9fb55857d9f677ed3661bc35590fad9dba8c7c3228e4ac918b"
    sha256 cellar: :any_skip_relocation, ventura:       "f1ecc20cd74bbf9fb55857d9f677ed3661bc35590fad9dba8c7c3228e4ac918b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51271131e86baa04b3b92e09c20ef7514ce36fa7d5f7a1867f229437d895ec34"
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