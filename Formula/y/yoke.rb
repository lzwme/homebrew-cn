class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.17.0",
      revision: "a56668f84acc4ac1877f2d148b6bed6a57b69bc5"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c84802bce73b2c25716630cd5ecb3985a99cf99eb603d7a9f8112ba982ea16e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8da08a9d195d333e36b16a352b42b0e41e12b406ec0cf9dee8a7f2d70077d50a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db66db4601152ed8f5e811a3d039b3a3b3bea0f25aac6c747fc50614e87c31ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "f57f3e454ec68c7b7169fe3970f1ee7ecdedb200063a228eab12ae4f2acfd2ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b534c7f3c7c9d85d7a2bd2723542a69990c70acfae34adff17f3918521d0096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37d0ca7df3062eafed1745ad7f0c8240e2824d6283ed2d3fbc39bc3a0025c1e4"
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