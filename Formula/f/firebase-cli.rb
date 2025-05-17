class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-14.4.0.tgz"
  sha256 "7ca673cfd09fdbd42b8606fc158cd86a4077575163f62f75490fd2dcc4387d00"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a6ffeed988dca37958d65290b39526659874b7be02cb17846f10a8a0099ba3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a6ffeed988dca37958d65290b39526659874b7be02cb17846f10a8a0099ba3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a6ffeed988dca37958d65290b39526659874b7be02cb17846f10a8a0099ba3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2506a49837184342af3d8d7881bed926d8f8710c540f2a78868b6708970024d0"
    sha256 cellar: :any_skip_relocation, ventura:       "2506a49837184342af3d8d7881bed926d8f8710c540f2a78868b6708970024d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0922b6b74b50cb900a22ecbc66cb15a7ea1752cf0bfaba6e567b8a32ca4cef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea1cf59eecfd7a324460ff0e465325b91061c23efb3cc6f2cf2046671f5a910e"
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

    output = shell_output("#{bin}firebase use dev 2>&1", 1)
    assert_match "Failed to authenticate, have you run \e[1mfirebase login\e[22m?", output
  end
end