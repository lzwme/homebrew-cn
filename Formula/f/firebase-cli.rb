class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.12.0.tgz"
  sha256 "811a9eb0621e95d062b09d119527771eb0703993ea0251fdd3a0fa9382f58aed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "572125954b0d9d0f48f8b5b328fb2a17c39b510dd8ce24f4bd3fcde5f696586c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "572125954b0d9d0f48f8b5b328fb2a17c39b510dd8ce24f4bd3fcde5f696586c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "572125954b0d9d0f48f8b5b328fb2a17c39b510dd8ce24f4bd3fcde5f696586c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4817c59974fad38325022ec2d91d691c4facf66e6cf633350d265785575f92ed"
    sha256 cellar: :any_skip_relocation, ventura:       "4817c59974fad38325022ec2d91d691c4facf66e6cf633350d265785575f92ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ab73d955eb27cc2e2464cb1e8fdb7d14889bf21c52e7670c975a939e1431729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f006f32f69172c71255074671745b82d5a2161abb5f1d864d0d45eea0920691d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Skip `firebase init` on self-hosted Linux as it has different behavior with nil exit status
    if !OS.linux? || ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
      assert_match "Failed to authenticate", shell_output("#{bin}/firebase init", 1)
    end

    output = shell_output("#{bin}/firebase use dev 2>&1", 1)
    assert_match "Failed to authenticate, have you run \e[1mfirebase login\e[22m?", output
  end
end