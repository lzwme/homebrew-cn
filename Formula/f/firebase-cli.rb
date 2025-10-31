class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.23.0.tgz"
  sha256 "87e6e9950d4232a443b9e73bbe142907163618980229e7c623101183a1a53b73"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0531c37e20c0e806d8021240587e3e7aec529f61274f6e817f0e28bcaad65723"
    sha256                               arm64_sequoia: "05dd21491d4fb046cc621fa6f35c64e5630e33fac8cb478fc1f201cd88f37bbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c391a728b4bb56d087a6e3bd3980ab431c2b6241a7ea1b53473cae79636fb285"
    sha256 cellar: :any_skip_relocation, sonoma:        "c391a728b4bb56d087a6e3bd3980ab431c2b6241a7ea1b53473cae79636fb285"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "992c44f9a9604b900b2adbe70ae17343fc44fea2adb3fa958ff5fa0345dc6a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581c22b8e679bd8a11a8d5b118e3dcbe3a1e7b7d28f10a05b57a430787361563"
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