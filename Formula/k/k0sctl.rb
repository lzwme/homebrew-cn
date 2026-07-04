class K0sctl < Formula
  desc "Bootstrapping and management tool for k0s clusters"
  homepage "https://github.com/k0sproject/k0sctl"
  url "https://ghfast.top/https://github.com/k0sproject/k0sctl/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "97d2112b5be95e55d9a88e65963e0cc61af1958b7c620a25281cfe06b58ed619"
  license "Apache-2.0"
  head "https://github.com/k0sproject/k0sctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35e7d8dac5ba5d15615d8b58edb096e4f26ec7bb6d6a5aa4536f41baa4b36893"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35e7d8dac5ba5d15615d8b58edb096e4f26ec7bb6d6a5aa4536f41baa4b36893"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35e7d8dac5ba5d15615d8b58edb096e4f26ec7bb6d6a5aa4536f41baa4b36893"
    sha256 cellar: :any_skip_relocation, sonoma:        "b940c0664b81d8fbde52225cec3efb2f0851581cef8ddd9dffdbe435e2f0dca9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96b1309696eb5603e2bc59529479c58f88e696c312a6558e1c4c294a796cbfd0"
    sha256 cellar: :any,                 x86_64_linux:  "5fd4ca0481c51a3a3a5df9094b012d10b7db4afa50cd9f8662c0b934e5c26899"
  end

  depends_on "go" => :build

  def install
    inreplace "version/version.go", "Version = versioninfo.Version", "Version = \"v#{version}\"" if build.stable?

    ldflags = %W[
      -s -w
      -X github.com/k0sproject/k0sctl/version.Environment=production
      -X github.com/carlmjohnson/versioninfo.Revision=#{tap.user}
      -X github.com/carlmjohnson/versioninfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k0sctl", "completion", "--shell")
  end

  test do
    assert_match "version: v#{version}", shell_output("#{bin}/k0sctl version")

    output = shell_output("#{bin}/k0sctl init")
    assert_match "apiVersion: k0sctl.k0sproject.io/v1beta1", output

    output = shell_output("#{bin}/k0sctl init --cluster-name brew-test")
    assert_match "name: brew-test", output
  end
end