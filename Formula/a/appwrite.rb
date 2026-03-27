class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-17.0.0.tgz"
  sha256 "5af147a3fc0163746ff5c1143bd47d2aee6d8eb2ac30a35e79e1129f36b5bfe8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6562a6180840cdb027fbcde245eca93be9b6b4a792780dc2ad2ec708cabca310"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db1af270e64d492cf7dbb08b3df27ed410be2789598c7e62b3687ebd228d7120"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db1af270e64d492cf7dbb08b3df27ed410be2789598c7e62b3687ebd228d7120"
    sha256 cellar: :any_skip_relocation, sonoma:        "d107d37e02f96e07e7eeccc4080aa2cdff5dfed1b248e2c3b59af7729d966673"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8a1133c9d19b3bd1bc8faaaf1231eb83f85d8a64ff0eb00a9bc5232e5fe0a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8a1133c9d19b3bd1bc8faaaf1231eb83f85d8a64ff0eb00a9bc5232e5fe0a0d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end