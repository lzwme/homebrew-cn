class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.16.1",
      revision: "702919d5bbc9d509942ffb3d8bebdd291f2623a4"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "893b60029fc45f32006cd5b148e901cc3433e2a35817d310ae809145df148201"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "191a89a1e18f60d4a40ea64f07f1228d4aa45c89a94cfea9910c9883649546b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e13b9c9007ddc8b68dc0784f009da5e56b7724219f192278c8d41f8f4ab071b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f55c632526cd5d63415e12883be639177b5c011225f24fc5057dddcd375e2b2c"
    sha256 cellar: :any_skip_relocation, ventura:       "3d9f85c389f3ebec2c1c0f43d21d2655d05a142b8f867d7571c06763568d6a46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a03921f9e480d2768f8b041388c0fa390961586fd63fd0223ab03106ae428e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cb33baf9e1799e0460d0d4d28f9148042c2eb54cb9e181fd3ba3acad053cfd3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end