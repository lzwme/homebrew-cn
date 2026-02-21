class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.7.0.tgz"
  sha256 "dc6f34e5203396fe4295c84fa21577776b1c8abfabbdd4fa80c97bf894703b4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2595a2e2f4379bb42143d4000dce46c0f132747f5b3b5996d96b497494f76072"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c9fd17b85d526f397ff064c3b83b5cf987781bd946ec5b64c21d1c6d6327dd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c9fd17b85d526f397ff064c3b83b5cf987781bd946ec5b64c21d1c6d6327dd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "07c9c93acda7d780557991d2d725757e0e94239109f59a4ac94b67e6be8115bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4ed57cab365a1bb79d1e11ca02d76b3e5270ca987694521ec82911c7552c7e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4ed57cab365a1bb79d1e11ca02d76b3e5270ca987694521ec82911c7552c7e3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end