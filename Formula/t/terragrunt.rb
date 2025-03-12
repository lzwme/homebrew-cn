class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.75.5.tar.gz"
  sha256 "1e87aea04a4f246d10e7a65b90589f534481353b10477670f087d1224c7298da"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c729b684b957e553f4e90395db9e549a7d467da5ef33fed2283f1c7c41864468"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c729b684b957e553f4e90395db9e549a7d467da5ef33fed2283f1c7c41864468"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c729b684b957e553f4e90395db9e549a7d467da5ef33fed2283f1c7c41864468"
    sha256 cellar: :any_skip_relocation, sonoma:        "770554bf49403a5dff767cfab059e27d5b94df99aedfb36d98be21c35b4df8d1"
    sha256 cellar: :any_skip_relocation, ventura:       "770554bf49403a5dff767cfab059e27d5b94df99aedfb36d98be21c35b4df8d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e891a637838253820d29166db610423a0080218035f6a57276771be6fe04f514"
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