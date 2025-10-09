class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.19.1.tgz"
  sha256 "011450a07d686d2b17438ae9f290ba14780503f17178290b863ce550566aa042"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "734d29e94e8943e0e46bea2eadcf82459523613eecd69d952af0068d2dba2ebc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "734d29e94e8943e0e46bea2eadcf82459523613eecd69d952af0068d2dba2ebc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "734d29e94e8943e0e46bea2eadcf82459523613eecd69d952af0068d2dba2ebc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd3a57bfef23bef80bfaf3397e1e89e87ec14e9df745b6c67212ec41eac7159a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e28a718890881c6fd5854297f213e5b431ce76481b43a248fb397f7ceb178ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13937c96efb30089c29c117220af0e052918551ab395e942378e1fdf79b3fc02"
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