class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https:yokecd.github.iodocs"
  # We use a git checkout since the build relies on tags for the version
  url "https:github.comyokecdyoke.git",
      tag:      "v0.11.5",
      revision: "cb56c0062fa70babe11e309162751882c06c0d87"
  license "MIT"
  head "https:github.comyokecdyoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d02130bb6a666556aff2bc9b6881766a62383ec45bab815c2ee18dde6a353cf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0e66123f90368514f4d5a9e54f4a3a90ef5de9fb885678a8b5cd6fac6782bb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce5bc2e3c11ca1da8f4c30708aeb0d8e68fc7bfdfb8200dea1a678680ac0d5a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d417a495c5d028e6b1e795273d98907904e601e1fe5aac0ba282469ed6582a06"
    sha256 cellar: :any_skip_relocation, ventura:       "5326d941ac6baba24a5b134e8c4e2905d992dd2dd97ca92c61dacce4309dd55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8755eacffd3e9c9a118e8bd20a83c0d3039ff75757dea2ceaa28b3f2cfc99fb8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdyoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}yoke inspect 2>&1", 1)
  end
end