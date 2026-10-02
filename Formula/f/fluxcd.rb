class Fluxcd < Formula
  desc "Open and extensible continuous delivery solution for Kubernetes"
  homepage "https://fluxcd.io"
  url "https://ghfast.top/https://github.com/fluxcd/flux2/archive/refs/tags/v2.9.6.tar.gz"
  sha256 "3ce69f8df361cdd8bf2751faccc4c86c9fa536a949f53d5632e078e27efbddce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a3e44b6e62ccef07d5a4a591eb4d02615c38389220e2fab07a64c89ecab964e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9984a689ae76f67966ba85f5942bd6316f8337747dc2b90cf88d86479a29658f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42ce1cc25e7e480ca8063a9951a46b28501a5e9831dba06a8a1e0b867c7b588d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "60a4b332935cb38857ad20d822f3071577fddf631bedf21ddf0b4a53f207a5ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "526456bf418f28ea2c0e9bb80bda4abfe1f5858a09ea40af2a6f305c7d918768"
  end

  depends_on "go" => :build
  depends_on "kustomize" => :build

  conflicts_with "fantom", because: "both install `flux` binaries"
  conflicts_with "flux", because: "both install `flux` binaries"

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "bin/flux"
    generate_completions_from_executable(bin/"flux", "completion")
  end

  test do
    assert_match "connection refused",
      shell_output("#{bin}/flux reconcile source git test 2>&1", 1)
  end
end