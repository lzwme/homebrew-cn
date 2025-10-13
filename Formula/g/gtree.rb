class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://ghfast.top/https://github.com/ddddddO/gtree/archive/refs/tags/v1.11.9.tar.gz"
  sha256 "db2226a1fc1c666ab8a750a82b36531449f976c298dd9f13f5d2f637fc41b090"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a418a0410666ac43810d61badd3e1ef34a81f2239d69294af4dd73f8a840b353"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a418a0410666ac43810d61badd3e1ef34a81f2239d69294af4dd73f8a840b353"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a418a0410666ac43810d61badd3e1ef34a81f2239d69294af4dd73f8a840b353"
    sha256 cellar: :any_skip_relocation, sonoma:        "318cca6c0a077a895840c72f28278afb3afc5839c94e9aaec07dfb043790b31c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "466da54a101f76bfa4495bceea835f623f1a6c799ab67a5977da4b584f9c1783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c27b5fe1dc267c89ef824b06e74abb23192b7ffa1598c0189dc48ad994375432"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end