class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.16.4",
      revision: "e4a309f4e138630c85a560464cb7085b4356e774"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22078ce0a490ccdda6b407a4fd5b9b3d469821b7164d64b3c353de38ccc842f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "697b52a016c03ee905f978548335c5f6a7038c0b36dcc2bbae4ba57f8ca0e126"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2974b5212d23d9b99e1cf77bde496ecd2603e7da7c122dbc6b946cba30802f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "eefdce833613de924a9146a9298ee5315d44b2664a67c130f1b0c09f330734ff"
    sha256 cellar: :any_skip_relocation, ventura:       "83f1a2128854e2cb2c8fe7abd8f97335cca8727603543b7ff563c8b3c0104969"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2889590b4afa463ecf89f2dc99780c27b049576b16d49682402509e723ef5b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad025bd4a9f7c9ebc44738c16d6de7655e14576944f69f97ef4dda5b2979585"
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