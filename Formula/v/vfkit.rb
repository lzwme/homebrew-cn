class Vfkit < Formula
  desc "Command-line hypervisor using Apple's Virtualization Framework"
  homepage "https:github.comcrc-orgvfkit"
  url "https:github.comcrc-orgvfkit.git",
      tag:      "v0.6.0",
      revision: "467a63452ceaf34beb8c3112713dd6fc0198f835"
  license "Apache-2.0"
  head "https:github.comcrc-orgvfkit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83741ac07575350b4c819b70b291029828cac87a8bcbb94535b57296f15f9546"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6829dc7d2da23e3f4dfe1f146cdd65b74d41908fc40e50908a55452dd2bcf45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81e0474b832666ce417d2ea5ccf9c71784a8a977762f0301beb5fb3aba78f4ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "a48302fd279c84d501b902c8e223171973d4fbb61c8b8e1036cbf774f52d6e77"
    sha256 cellar: :any_skip_relocation, ventura:       "dea4fb7662382b37d239b7fa53a7eb6a9311566c55f44bbc14b7aee2a7572b62"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    system "make", "outvfkit-#{arch}"
    bin.install "outvfkit-#{arch}" => "vfkit"
  end

  test do
    version_output = shell_output("#{bin}vfkit --version 2>&1")
    assert_match("vfkit version: v#{version}", version_output)

    # start a VM with non-existing kernel
    output = shell_output("#{bin}vfkit --kernel foo --initrd bar " \
                          "--kernel-cmdline baz 2>&1", 1)
    assert_match("foo: no such file or directory", output)
  end
end