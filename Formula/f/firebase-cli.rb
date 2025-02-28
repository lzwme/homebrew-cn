class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.32.0.tgz"
  sha256 "b021216f636bae7552d2f289d9a2d20e704f996c7794e132622711510d84415c"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "76223431dcb7e2561f042431cf020e48f6335f18e22f5555d3aae074c9a46225"
    sha256                               arm64_sonoma:  "90d5329689fbb5b2dfe25ff7daef05af232449dc88303de77ad7009cb7708eca"
    sha256                               arm64_ventura: "141b6abf25848210cd7d5630827541b09ead0a85789e58d5840b1927b4d77ae7"
    sha256                               sonoma:        "bf13ddb8b4c9257b88e17af7dd835377c57dcd8359e1ee45acfd7f9f7d2a58cd"
    sha256                               ventura:       "2c62e1431863f6af9d914d5531e84f1fc3de6fb38ea20b5a8b3734e4a9e061a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30bd956fda4e233cf1e09a69ad7dc99d5db722c85a434794d89ecba55500ceb3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    # Skip `firebase init` on self-hosted Linux as it has different behavior with nil exit status
    if !OS.linux? || ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
      assert_match "Failed to authenticate", shell_output("#{bin}firebase init", 1)
    end

    output = pipe_output("#{bin}firebase login:ci --interactive --no-localhost", "dummy-code")
    assert_match "Unable to authenticate", output
  end
end