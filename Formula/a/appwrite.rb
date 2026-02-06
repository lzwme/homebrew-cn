class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-13.3.0.tgz"
  sha256 "c8f888c598f6a2a5f3c5d06c220739be1a1188a76554da723a9509f9d9e303dd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ce217157de1e47a5b02ee6a9796dcdc267a07c8ce4ad4d5c10f3d8e5f80d716"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94cb672e664ba332059587bdad5b3fce25060a94b709a9e0a1daaac72577c02c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94cb672e664ba332059587bdad5b3fce25060a94b709a9e0a1daaac72577c02c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e2eeaa6e8d310e17d0714e8faec8bb591d526c83fff85c9616a269eaf36675a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8e1e191de4face4fe99d147877f81a931089ee71cb59d8c7026f714b5fc415f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8e1e191de4face4fe99d147877f81a931089ee71cb59d8c7026f714b5fc415f"
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