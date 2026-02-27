class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.8.0.tgz"
  sha256 "058f10be9fbbdd9a2d237008e6bbd9b71b1f0c26595d383e942aed1a009737a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89ccaf3be6facbbf30a093fa30e720970b98867396065b28ba3b27cfa05c417d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a817b20dd3e60d2476a24e0ced97d37d3f16e1cbbc9524aad7394b788e3d4e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a817b20dd3e60d2476a24e0ced97d37d3f16e1cbbc9524aad7394b788e3d4e7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b20d9975772b9afb0b2c573b264d582a4843322995e3f02d5c97868390429cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc617f5da1f5f0490f1b5399e0cac131bc6e58d18ddaced1ab57cf90f8079aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc617f5da1f5f0490f1b5399e0cac131bc6e58d18ddaced1ab57cf90f8079aef"
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