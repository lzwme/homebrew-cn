class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.24.0.tgz"
  sha256 "73cb1fa4dedd9d79b3f420bc64a6f5981aa814cd4070fa0eef579d34390ee1a4"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1e1d36987fdc4bcf5629fd7b8d450e1edebd21351e019c5b3a356426fb8daac4"
    sha256                               arm64_sequoia: "b8da2250bfe5a18280d33c6e95d828d2323bd79742e8f9131c6e9d33f983225b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d5ebee9b5353a610598adb296cb95d17cd10f80dc80b62d6fdbe069c8a59923"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d5ebee9b5353a610598adb296cb95d17cd10f80dc80b62d6fdbe069c8a59923"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "037c0f16f74470eb654e59e43b9ed0e9a9f4bb1f4a9e455dc06553cc7b114fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eea933bebbb98c615c0d8e840d75f81bd2d4807f5c4dce503dc5e76a6536009a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end