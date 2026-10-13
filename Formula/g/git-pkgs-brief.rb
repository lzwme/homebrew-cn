class GitPkgsBrief < Formula
  desc "Tool that detects and reports a project's toolchain, configuration, and more"
  homepage "https://github.com/git-pkgs/brief"
  url "https://ghfast.top/https://github.com/git-pkgs/brief/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "2f329799ee6772a13e1def9a767334cf58b682dfccd8078b040dde5e717a3670"
  license "MIT"
  head "https://github.com/git-pkgs/brief.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "771dec52891babf0bc7cc5c6464346d3693b2f0399a604262f43d2853f01b52c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "771dec52891babf0bc7cc5c6464346d3693b2f0399a604262f43d2853f01b52c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "771dec52891babf0bc7cc5c6464346d3693b2f0399a604262f43d2853f01b52c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e378cc96a164dc9f2bf1143fccba567e600e0669c9f2e327faf7ea83eefdb568"
    sha256 cellar: :any,                 x86_64_linux:      "41a92f6a7375700d4f2616d9d2d7b7253706aab7e6a9c104b698efbb7e438d55"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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