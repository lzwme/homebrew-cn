class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.17.3",
      revision: "aa9be9de70460b7f416a20ce616c4b59e1d30354"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01a7ad7cfe133d883663b33643c0d16c6b7070fc558629fd46d3ef4159a44ec0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fe4af2d55e14f8ca2631cedb70481cedc106ad7b2ff4e3b0674e1fba95c10b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59f662c162313332cec872323ebe14ff6e411fe03e420c579e3d398ba1340430"
    sha256 cellar: :any_skip_relocation, sonoma:        "92078c7209aaf3b3d2ba9b5c994cc94a3deac50e6216ff380f92b042cf16e8e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd84b20e924e26b441ff78e8e244080a27cdf612d47da356b089223f3bab7e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40a2457a84e9cbf19516743803e83543a7c8035cdd16a01cd00307132950a6ea"
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