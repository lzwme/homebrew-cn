class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.24.1.tgz"
  sha256 "c943f50fda74de58db8b400c68fd6ad2e88ab7e697ff5100de255c89ed96af9f"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "bf8c0c0974a9fe46e98136232d381548f4e9355420ec4d5b9c3c0742f74c7c30"
    sha256                               arm64_sonoma:  "9e4eda9c930f01fccca2bced59528b4030b7984e3cb3400687dcfd54ad112eef"
    sha256                               arm64_ventura: "6bd2a6d3b3bc304dfad0ac964fb55593413f49e03f1b53c2430e0a8ee1424564"
    sha256                               sonoma:        "8bfea3601abc791ed29b379b4d273223cd709f25b6cd9468beaa5842870d0f6e"
    sha256                               ventura:       "e90ea508f8e924013a97d7e156efe154939d6d7f6ba7dc1a486c3c9a2f2dcbe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ef9e335de4b39aea3109ffdf46e59d8fa94ea4ef25decd2c464862ede8a6e56"
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