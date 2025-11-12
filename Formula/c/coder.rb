class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghfast.top/https://github.com/coder/coder/archive/refs/tags/v2.27.5.tar.gz"
  sha256 "bc7b2ad7d696634d9127786324ed5224806485c04eabf5dd5325b1ffd5f8823f"
  license "AGPL-3.0-only"
  head "https://github.com/coder/coder.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2623e3f21e6fae0a5e5fb34cae56a645d651f835b4be8d9beb3e8e4f28def248"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c67e1bd61370727b43ec204d76e296eb5f822e9cf5534b409213d35767b55a6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34c3ca8a8fd49e80d7cd33ad081dac714db6a53da013e9b7b301d620ead6ccf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef985fc50f703c8fce6cd1b11ac7e8379d7dd7fba8fe6a66d8c09a7d83939bee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84201b5d1623fe87dec43670c45b05630bb29331febf1364c5e1f28427b7734b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fc5b9acfa3098be485712f9839f204e69d293e26c6edf0e68deeb2184bcb950"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
      -X github.com/coder/coder/v2/buildinfo.agpl=true
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "slim"), "./cmd/coder"
  end

  test do
    version_output = shell_output("#{bin}/coder version")
    assert_match version.to_s, version_output
    assert_match "AGPL", version_output
    assert_match "Slim build", version_output

    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
  end
end