class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.77.1.tar.gz"
  sha256 "a74aee5b0238c808c0243c44c6d38d127f5f27cdd82eb0e943a7504376b0122a"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd4652677bd1de7a0466152faea5a36a8709437bb5235c463b2c4382d7e5ae27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd4652677bd1de7a0466152faea5a36a8709437bb5235c463b2c4382d7e5ae27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd4652677bd1de7a0466152faea5a36a8709437bb5235c463b2c4382d7e5ae27"
    sha256 cellar: :any_skip_relocation, sonoma:        "50e7318fe2982457fd12864f62016483bb465a84c4225d545cb74ef9752fb355"
    sha256 cellar: :any_skip_relocation, ventura:       "50e7318fe2982457fd12864f62016483bb465a84c4225d545cb74ef9752fb355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "404ab09fdbeb7e003d46f1ba7f985372f6c7d45e134383744fa81a0ef0739ba1"
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