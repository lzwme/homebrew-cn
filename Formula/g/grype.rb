class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.79.5.tar.gz"
  sha256 "faf56f137d4c3908e0a89dd483da2e399ee302a6f2bc5017935980bdafd402cd"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e16aa857350c933136b6daa199168dc68d6dbce0af3af2f24e64b8278d3a49e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "183f8b347fd87fc113d79fef6bc6ec6af1c283ca67e2de1c8f0739b33dc34eac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d853c1bce5d015a60bd479bdccae7353059eef0de874051888080fc6486c45a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9c6de541fda3171470539ea68ded02676fa894c9245732fa4e6ce2f617ba970d"
    sha256 cellar: :any_skip_relocation, ventura:        "c7a118ecc2fb9a65dcbfda75cea654886b4e38b90790d73a727a56a39c639b3f"
    sha256 cellar: :any_skip_relocation, monterey:       "1168c1d79e10f662a402af4d43284340fa0f0639e97d82bea4c940298cf4cdf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2047b6ea4106ed36e7bfcabc3ad27866dc6cf7330bce5619db65ef84f365e187"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end