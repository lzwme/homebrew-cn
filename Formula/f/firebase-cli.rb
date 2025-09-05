class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.15.2.tgz"
  sha256 "e2829c5dfe0775545159145ab2c6a5e33aeb009a1993ade1b2b66d3816851364"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b8968ce9ca9f39c7fbcf9e6e9db008add9860e548b5cead1df6759338005ccb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bf98d1c2d366776bde8552acffcedbc3b2dd3e8d70a7f19e91b55018d51a9ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bf98d1c2d366776bde8552acffcedbc3b2dd3e8d70a7f19e91b55018d51a9ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "edc06a103e697d9d3cb3eed39dc4ba78841633a38fcd915445c6b6f22887ba54"
    sha256 cellar: :any_skip_relocation, ventura:       "edc06a103e697d9d3cb3eed39dc4ba78841633a38fcd915445c6b6f22887ba54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c631774c21593e37553f75e56f1b5aba0dc8888a8c96073a53d7bb6e8e7e694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c036765bc0abb699c58f4296b80ee6d19e3a705016c368c230ce7b59fdd9c5fc"
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