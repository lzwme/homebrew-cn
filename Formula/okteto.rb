class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://ghproxy.com/https://github.com/okteto/okteto/archive/2.18.2.tar.gz"
  sha256 "27bb8e3519219dd271811d2561210a1217f3370e022fe9e1be7017421973793b"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79bfaf40dd61a15f985e67817fc3c17b5e4c905afac60f9aba94414f4976bf45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8810b16abb3f080f25f62faeebfbc0aa557c15535a44bbe3ace5ccdde15c74aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ed2cf29f7e18184016b7e13247e7c486ec49114816e46bdd8a74f180b83c940"
    sha256 cellar: :any_skip_relocation, ventura:        "7600ccefb999a138062d8ca914bd24dc507a0477d67c4ece07ae2560cd5d2b0d"
    sha256 cellar: :any_skip_relocation, monterey:       "fae934980ea518f1e417fa89690086469ccb70e275b302e26505aec7b974e63c"
    sha256 cellar: :any_skip_relocation, big_sur:        "04ce8176fb90170a3e65dc5c2a4e385d5d6ab34dda2871d1248a7feb1522d621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a01053a77b07b08f9043f776c5c202654e3a86d66b5304ebc2896a53879af2bc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end