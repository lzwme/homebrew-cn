class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.21.0",
      revision: "6013565defe4d7fe273e5694103aa5c952a2bf58"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43c7bce3adc7eb1ebe5daa35c45d43d55430ab0d9a6a18a71f0c18026fcde8d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e05548fb5805a40765d4c412ce6b1461fce6495408e7e2f837073e995e0b7b70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ea797d9b9fd6aa643b147166e186e6a3b3cb51774b8b7fbc136bf5c8e6ab7bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "44d4c7ac3d24ecc322c8332eefec20a8bfede0666be7a2ada069b5619ff476bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d07e91534723902d92f53b24a73fdb8c2bce1e951489ab38f39f719256500283"
    sha256 cellar: :any,                 x86_64_linux:  "8f251bdd32abc8093082c82780cbf56adec7ae387f430f7410829a281896224e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end