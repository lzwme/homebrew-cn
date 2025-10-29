class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.92.1.tar.gz"
  sha256 "acea446da55c5ec12282361445926e21765123015aa4235244e5cd16323dbade"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff9cdcd9c7cbf3fbac59c7ba8e4d4603406a6971ebde60d4427d0b16cd005118"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff9cdcd9c7cbf3fbac59c7ba8e4d4603406a6971ebde60d4427d0b16cd005118"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff9cdcd9c7cbf3fbac59c7ba8e4d4603406a6971ebde60d4427d0b16cd005118"
    sha256 cellar: :any_skip_relocation, sonoma:        "6327bd6463e0f6c3b95377f9c364d417f92673fa31de50a28b81ed11ed83b081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eb4fc2210cdcd9627ddbaefcf295086b49f7805b7e9f64aba7bd1b7fff7c8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa573e0fde4e9e086b81a451a570fd45ab8c4c4554a013930990f773f940984d"
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