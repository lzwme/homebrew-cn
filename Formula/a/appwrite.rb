class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-22.1.1.tgz"
  sha256 "039ff20710834f0290d9df54832d1ab9f48d52e45280a7830e38fda54a6b3778"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4759329baf3a0611e7b542f18121bd56f82929d1ed3e7d5e1d24acad7a00bb3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e30fdb4509745e21b040f585036a66676aa24789d38a9e28ebb6173bd16e4c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e30fdb4509745e21b040f585036a66676aa24789d38a9e28ebb6173bd16e4c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0a4161ff62dbb02eb964d29d78411f9b191ccc1fc9925a943e65bfb623cb785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44613bd259bb8ee973065dfacad7cea0e71d64573f0fc49e92aa0134691b8e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44613bd259bb8ee973065dfacad7cea0e71d64573f0fc49e92aa0134691b8e9a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    machos = %w[fsevents/fsevents.node app-path/main]
    machos.each { |macho| deuniversalize_machos node_modules/macho } if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end