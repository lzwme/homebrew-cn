class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-15.0.0.tgz"
  sha256 "590c99dcddeecfe55a4f036284b1cb2e67de2e1ab3ee3dc82fd3863151974554"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c6653fca4e42a2281d0a75969004b1c90aaf017046b862c5d06f07cedf7f196"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38243c9b255b4b332644f1a81178885eb10bc5265a19b885c444068a1154083c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38243c9b255b4b332644f1a81178885eb10bc5265a19b885c444068a1154083c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d4ab4baae8369b985d15dd6aa607f620ff6910573d029e984f13b21df4e8a37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57c3e5c89e9f576f19199f4da2d5e4ace0be39829502f9463b440a457aa4deb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57c3e5c89e9f576f19199f4da2d5e4ace0be39829502f9463b440a457aa4deb6"
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