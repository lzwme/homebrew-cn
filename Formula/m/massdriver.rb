class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.13.6.tar.gz"
  sha256 "7654806a5f4c246ce5ff24c6379e65f35fdb99261dfeb4a2ad341baf3a03642a"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdad1efd502597a2f4fea4c777e387919b9605639153a2e698f0dc449a53bd0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdad1efd502597a2f4fea4c777e387919b9605639153a2e698f0dc449a53bd0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdad1efd502597a2f4fea4c777e387919b9605639153a2e698f0dc449a53bd0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b9c4e8275f89cd6352bef1a7cb8c5ad32a0505b309d72951040eea849e30c2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "009b39a3057938f583dd0cc094a0ba5e8951472a2a390d842aa871c39ca3a5fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddc4b0beaa5ade9737abd639ec56bb98a41527792d6f394f5d439794d406064f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end