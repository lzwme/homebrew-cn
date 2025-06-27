class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.9.0.tgz"
  sha256 "c225eca48435580d0c4b0551f05df8790c44653fa32c9ad635b73f46ee3b7b46"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "753bb8362d4d900afe355bc93333ac14983f560ddd12a091be5ba9b20bb5a13d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "753bb8362d4d900afe355bc93333ac14983f560ddd12a091be5ba9b20bb5a13d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "753bb8362d4d900afe355bc93333ac14983f560ddd12a091be5ba9b20bb5a13d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb9c9bb855d1f28ddaf44091020d78dad983e99ab5ebac32b42b5b7837cf239b"
    sha256 cellar: :any_skip_relocation, ventura:       "bb9c9bb855d1f28ddaf44091020d78dad983e99ab5ebac32b42b5b7837cf239b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21d86b01b68ec7ae9e2f06cd711d6661a8bb854d4bbdf192f07dcecc74da6bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "299e76fdcb7b52c4ec887e18fddb8512307921d5541171bc9f07f89a833424f9"
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