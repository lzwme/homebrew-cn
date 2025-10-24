class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.17.2",
      revision: "e9b73b6c569bfcf113e734f3c36ebb9a630c38a2"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4916e0b261b121f10f54b6860c3870387311b364879e924a97a889e1438dc9e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5061675dba7909e16a52d3d9a667c65181d0f6ba22cf035f611c9ea1acecf17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9547960fc54f55f787328855de8f94584e94e1606096eea3494914ed2980641b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf69dfad513aa1fd6be4d3174dab34d2d77efd808439dfa6ecc599d17fd0529c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aee8649c37a6691a76d8ed6cddd531e961548b032f336123103b939db00d411c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39a097a1c6c499680f7c25f7c4b60cff0bf4175a96fd20765e3c141a75a8d3c5"
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