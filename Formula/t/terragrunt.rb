class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://ghfast.top/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.93.5.tar.gz"
  sha256 "95cc60e775b4dd8dacbd009018ad1a8156b9c0ee7880471e153666be4b01f99b"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d603eba28144178943ebd9b386872ee71e3cae1b2999603265a0b027c13ed3fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d603eba28144178943ebd9b386872ee71e3cae1b2999603265a0b027c13ed3fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d603eba28144178943ebd9b386872ee71e3cae1b2999603265a0b027c13ed3fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8ceb6ad1f4e66d22240c953b0854ff585a13799795af16804d437da4de620c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c18264262c319621a45475cc3233cb74d39ad693640b7beb91bd8ee47700d06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7bf5f7ad30c9618425b056f8c3b9c21ddc264689c908ecb325af370de17604f"
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