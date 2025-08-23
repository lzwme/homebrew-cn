class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.14.0.tgz"
  sha256 "1bb40e229c5543af94fafa1de953ed78b74e6b9d43adac8ade2bbcdd48141303"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b042c00b176afeb0ac82641286bf811ab6b7961d07bc45ff851fae0dac6091c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b042c00b176afeb0ac82641286bf811ab6b7961d07bc45ff851fae0dac6091c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b042c00b176afeb0ac82641286bf811ab6b7961d07bc45ff851fae0dac6091c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f18fe602cd90ec9f6d27e5eb00024f3ae10b1382785dc7292939c4de9053cdf"
    sha256 cellar: :any_skip_relocation, ventura:       "0f18fe602cd90ec9f6d27e5eb00024f3ae10b1382785dc7292939c4de9053cdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eea493b57dfdec897f765cacc4590811de03d158b09cc07c2737d0a033ce0f31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e30b21720666ea2164a6acc5f76af561a86215a7a44487f61819ec83a00794d"
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