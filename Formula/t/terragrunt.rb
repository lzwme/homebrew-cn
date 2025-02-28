class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.73.15.tar.gz"
  sha256 "5a25e3bab8b1a2b67f46815f0d262a842284832bcc9826694319d0ee35e3762a"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d56a1ecd44d23d9ee2f19a80ab2be7bc99018274a4044c65f96ec8939568c20c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d56a1ecd44d23d9ee2f19a80ab2be7bc99018274a4044c65f96ec8939568c20c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d56a1ecd44d23d9ee2f19a80ab2be7bc99018274a4044c65f96ec8939568c20c"
    sha256 cellar: :any_skip_relocation, sonoma:        "34f05f3ea2c5988794b84a697c8fb6fab0eec4ca5f1914c20bcd0eb60fad4182"
    sha256 cellar: :any_skip_relocation, ventura:       "34f05f3ea2c5988794b84a697c8fb6fab0eec4ca5f1914c20bcd0eb60fad4182"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddac5a36717dc5e5ecfc1b2c223c924c2712f393fe90146daba35a69f3c12d61"
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