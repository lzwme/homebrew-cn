class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.20.1",
      revision: "bc9c576a790df8c42aa06b90fb406220f1de22a0"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7525f2cfc7cb138a70a171cde6b85290022dac48fd40f07992caabb53e2ee1ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "901f7011b70798ce7fa22a233c13aa5bd64aae35c81af352fba900075b2802c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d160c74dce55cfaa7da848fa7fd4f99a6bde9e7142d606456cff23dba1769e2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9914ce9a22878ebbf035606f5e9397b5649bd11ee3aaad69541329af13467f26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffe53c12580902bb41d9acbe3285772b56cdb89926b95d647df8e174f5ebe0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e22bbca058d00e738872d5ca6320d9dc596800fec4b1af1baafd8837d9d172f"
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