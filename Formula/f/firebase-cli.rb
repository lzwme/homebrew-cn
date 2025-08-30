class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.15.1.tgz"
  sha256 "db3322069c3502f48ca8f7fc917a59e161fe963937b2e7a0335e628075816ec3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6966ca12aa16e7353fc504dd8fd580f501e5703a6acf6c38345eb71425ed863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6966ca12aa16e7353fc504dd8fd580f501e5703a6acf6c38345eb71425ed863"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6966ca12aa16e7353fc504dd8fd580f501e5703a6acf6c38345eb71425ed863"
    sha256 cellar: :any_skip_relocation, sonoma:        "6079d756f6a4229b5e3b1a327c594b28f6c9a54631a4f2a85db58ede12e4bb85"
    sha256 cellar: :any_skip_relocation, ventura:       "6079d756f6a4229b5e3b1a327c594b28f6c9a54631a4f2a85db58ede12e4bb85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee1755a63089a0d580eff31af6766eacb5e3e1d834f7eb1de49ac9e3e622eefe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfb90fca4c84527cb568eb56ae830f34e534c9b01d693d28cecdc17f62e0f25a"
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