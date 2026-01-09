class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.2.1.tgz"
  sha256 "33f5775fc3bd4b42d412cf25d5da308b70fa92a3fd040794a13b862f83ee89fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64153a13fd25392aa9f30a92f3450d08f103bda7e99891c77154b69535ae8601"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0173bc3455411463fdbf076958afecf71e73fe749b8e23dfbcb4927bc138f376"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0173bc3455411463fdbf076958afecf71e73fe749b8e23dfbcb4927bc138f376"
    sha256 cellar: :any_skip_relocation, sonoma:        "9455b797b355d286cfe8472129b7b70c18223163e7f8e4f9b873234f5b6d2344"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7400e1fc24e89b9db2ff69f98a65369883b0c28f7e3a58cb207c2008a3bbe69b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7400e1fc24e89b9db2ff69f98a65369883b0c28f7e3a58cb207c2008a3bbe69b"
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