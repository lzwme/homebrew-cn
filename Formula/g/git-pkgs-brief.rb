class GitPkgsBrief < Formula
  desc "Tool that detects and reports a project's toolchain, configuration, and more"
  homepage "https://github.com/git-pkgs/brief"
  url "https://ghfast.top/https://github.com/git-pkgs/brief/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "aa4aa70297764b6d2befedb9e147fc530efa62eb81dc90b84b739922ac0889d3"
  license "MIT"
  head "https://github.com/git-pkgs/brief.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17f546b80d0e633f2906f573352d1d3c66d6a09216c85360e55a06a93d18e29a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17f546b80d0e633f2906f573352d1d3c66d6a09216c85360e55a06a93d18e29a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17f546b80d0e633f2906f573352d1d3c66d6a09216c85360e55a06a93d18e29a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3d165a75cc82e581f957b29b3a7989b652c3c07b509b0f225c9909a6273cef3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27c025290f43707762e25c82db5d179fdcc06c60b7481cae8b5502f80ba6dbc5"
    sha256 cellar: :any,                 x86_64_linux:  "a753f754b9e7db102bf3b19659d090b47d41240a396801f9a93229f4e48be1ba"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/git-pkgs/brief.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"brief"), "./cmd/brief"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/brief -version")

    output = shell_output("#{bin}/brief https://github.com/Homebrew/brew")
    assert_match "license_type\": \"BSD-2-Clause\"", output
  end
end