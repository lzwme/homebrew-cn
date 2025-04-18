class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.77.19.tar.gz"
  sha256 "1fbdde566a6346316aeb6284fd61f0e89d71fb0858071e304f7d1e48afe20e56"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fd1e757f2d49e0d79ceeece3ffbb0e666872818c3f9dc95345462e7ff31d44b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fd1e757f2d49e0d79ceeece3ffbb0e666872818c3f9dc95345462e7ff31d44b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fd1e757f2d49e0d79ceeece3ffbb0e666872818c3f9dc95345462e7ff31d44b"
    sha256 cellar: :any_skip_relocation, sonoma:        "78176cddcbac90786befaa8f7ac74239989773752f71d7e9a9fc31f61d6bfdbc"
    sha256 cellar: :any_skip_relocation, ventura:       "78176cddcbac90786befaa8f7ac74239989773752f71d7e9a9fc31f61d6bfdbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e9f5ca8fa483c737a990147411a4f899fe7b8ef3035ee61bc40d41a8f94c4c6"
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