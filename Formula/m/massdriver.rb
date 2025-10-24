class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://ghfast.top/https://github.com/massdriver-cloud/mass/archive/refs/tags/1.12.5.tar.gz"
  sha256 "e523a287ee603e82857cd76bf85ed8f01ba6264eef60987c0b7547575f2dba6f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3616f8da386fa6bdbb117a1a0d69c0a82fb79d83615bfd23013a7c046c072181"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3616f8da386fa6bdbb117a1a0d69c0a82fb79d83615bfd23013a7c046c072181"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3616f8da386fa6bdbb117a1a0d69c0a82fb79d83615bfd23013a7c046c072181"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c4932e1db982f7c387fd3b06e288f1545d164e9c7984e7dc8542979a5f481ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92f0a6129d450f271734b3faaf2b72666c6a2da35f9e460219835112990fef2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "485ad99909a37416889f6e26fa3084bc1833972d94e889ff78d42c1a33fa1b64"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end