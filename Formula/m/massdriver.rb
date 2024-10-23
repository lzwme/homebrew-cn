class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https:www.massdriver.cloud"
  url "https:github.commassdriver-cloudmassarchiverefstags1.10.1.tar.gz"
  sha256 "1d4f6e337c614c802279917adafbe22856beda6a1311e7aa21b6849ca769a51d"
  license "Apache-2.0"
  head "https:github.commassdriver-cloudmass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5b3f5aaf837209a0502173a83500cce1506f4bb86a81c5d5e53d23035a8751a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5b3f5aaf837209a0502173a83500cce1506f4bb86a81c5d5e53d23035a8751a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5b3f5aaf837209a0502173a83500cce1506f4bb86a81c5d5e53d23035a8751a"
    sha256 cellar: :any_skip_relocation, sonoma:        "da2ccdc3a086559ffe63791f2da2727ef71cace9c1d03f91518abd2bb06d9ebb"
    sha256 cellar: :any_skip_relocation, ventura:       "da2ccdc3a086559ffe63791f2da2727ef71cace9c1d03f91518abd2bb06d9ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcafd5af316bab438196a2555897b9738358f08dca82c79fc6186097ce9e503a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.commassdriver-cloudmasspkgversion.version=#{version}
      -X github.commassdriver-cloudmasspkgversion.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"mass")
    generate_completions_from_executable(bin"mass", "completion")
  end

  test do
    output = shell_output("#{bin}mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}mass version")
  end
end