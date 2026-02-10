class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-13.3.1.tgz"
  sha256 "745d1b4492911625d19a5e172961cc6f759dba0d357756bada65904ed18a7c65"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fd6f95afd1bdf8279dfbcc8629e8674183d78d2b625926ec3fa87e0a4c886b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db890acc219ad6d8938eb963f1fb4fb8f0ad750d9deb411ae936b4c33bf49166"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db890acc219ad6d8938eb963f1fb4fb8f0ad750d9deb411ae936b4c33bf49166"
    sha256 cellar: :any_skip_relocation, sonoma:        "190f567d33f63b9fe20003bf4012ba6d77e31753710de10d71fa2b6f6870a205"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3806821c1122f48f6017bd650e3da6041a0c41c68f0be0f3db27f185318ea4e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3806821c1122f48f6017bd650e3da6041a0c41c68f0be0f3db27f185318ea4e9"
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