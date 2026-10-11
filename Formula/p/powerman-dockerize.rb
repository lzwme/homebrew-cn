class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize.git",
      tag:      "v0.25.3",
      revision: "3d7daff8fe0bcdfce5145e619f2712410585979e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "29024ed78719cb70c612994e07a52160fbdad44ae85c15b95ae3e22eb75f3c3d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29024ed78719cb70c612994e07a52160fbdad44ae85c15b95ae3e22eb75f3c3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "29024ed78719cb70c612994e07a52160fbdad44ae85c15b95ae3e22eb75f3c3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "95ef14092ebf49ba05d9ad78ec62175b4fca4fa76933510768b479c9f9e51046"
    sha256 cellar: :any,                 x86_64_linux:      "bae286d15738680f7763f12ebbf0f392e0919d10d8e2005d71df2589c3044ee4"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end