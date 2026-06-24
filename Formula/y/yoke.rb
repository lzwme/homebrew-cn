class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.20",
      revision: "685940d43377f2a80aa3b19faf06c179f613e521"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b590ffcaa413208b44a2ccf31353ca1a0dfdfeddda222490f09c7dc763065068"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "523e15e1ee147fab7235b5d3d2f161b773263dfa41e4a94f0ab7e6b8bd1bd4b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3652a03f936db8b587073fbdf8536aa95829accd54925af7cfb4071b457ca73d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1dd50db113dc07e9e9a617cc021d901d1305fb6814de21bd71ad0b3916aa0f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dabe13275045e5a6b457c56dca8e694bc5bc4205eedc23a1dabd7d89d00adc52"
    sha256 cellar: :any,                 x86_64_linux:  "4b3e2cb0e5b34b9440d7e70b9d1097ba9ddfdae895cdf33f7a6d2e82ff85048d"
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