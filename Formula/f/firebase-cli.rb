class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.28.0.tgz"
  sha256 "67834b0cfba5cf49fe474c54cdf2e81eb8f1ba0f011b4e29852092735ceb3deb"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "8af18646fce82ebb01a82eda9143d48fd6549336093ed1f937731616e5199c64"
    sha256                               arm64_sonoma:  "e4a23a2baa852899a0cb266efaae99e43a46d79cf3d66ccd895ec398d8c51e9a"
    sha256                               arm64_ventura: "b291c071aa3f0031b271ca3df505f1168987604aff344ba24f1cf6dab0bb0148"
    sha256                               sonoma:        "8ff318c3b33ce39014f4d2d8925083fbfbd4f8a750eff04072d16c8305711095"
    sha256                               ventura:       "6d12f3eb1bd2785dc4cdd6bd4ec2db4951707a6ed3f9c9ea279263c307619405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad480f1828134237454de501121e548f81b0f1cb14befe0d039e895bb51f3228"
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