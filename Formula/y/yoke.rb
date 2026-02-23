class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.4",
      revision: "9e0cb6df8ef5d1fb94a51e2ec95c876e8e2eb709"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a06bdcd664ad6274ba5997c8dda26f0bd15d40787a188d3b64944abf905824f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c74a16fb483b245d093894daedaf846fb06f0a5cdbebed49a92a17bf10d527f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cc8c57e661456edfd9223511d403ce83af144dfbab49225fedbda00320d54ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "c97fcdc782b40f2f571bef6d7ff15196d4d726848b97aa81edff16c773d55334"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffb38878e4d1ba4c7efdc257fb91a4ec32a4e881884d9b5cb282165406d9e3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "355aa2cc70b1e0db24694c8aeabb11121f4066995ff46ed621953de01203b64c"
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