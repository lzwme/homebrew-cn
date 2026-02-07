class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.0",
      revision: "f97305640524f75df4f658be45edca0b0196beb7"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "195c52a782dedbf85287f4c0bf825c11c3de77658442a677453968c612e6cf57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd6e0a1b1308ccf4413af2796d0cc75489bfe317a8fb588c8e062f96a85e1c76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ea495acf8b294a9d4d2f5436429bb071c4198998b93f07ff74c6e37656f0bb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2fc103465af2587362aa658ca22d2210111f0daa96e2ad92b1578acc90c8928"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa293fcbfcbeeae44993af0d01f667bb34cd7bf0ef7f35687c7d7719d025199b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8d544129d61e978261f2ce5fee9de92b102f8ff960680008cfe953e03ca7e3a"
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