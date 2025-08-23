class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v1.16.3.tar.gz"
  sha256 "0b09f76f9ba43a406a03b23b43d083f8d55dcd17682e2b02c70c87cf211ce23c"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0b2c67fcc903724f1250270bbaf6ba773e4e6084ad5c4ea99b707e5276a45f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5cfc94f1d329ed51d4170813d0544f614d10994b7460a934a26ec3ea6755d8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8dc6960d06d8d1bbfa035e52c63e22b80d5ccfa675b89799aec126826837eeb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "add52184129ac3a81709fa346e596833e169073b3f0081231571c2d357d39189"
    sha256 cellar: :any_skip_relocation, ventura:       "341a3eea5290f3862f91604764c1975206d815fd7878e16c4a9923c37baa7a6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ecb94024f6ff94dab422edef921fd9e92ddc2ca57e207a5c05f757438ceb01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cdc8ee4f04cdf4f2931735126a1fefa4b2e283adca6a6359c0488cbe6df9a89"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end