class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.3.1.tgz"
  sha256 "3653b109eb55bafcc760f895811decc0315b225061b1ef3f13eb9dc50d5dcf71"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "d5235447a7f286ca4fd84bb0fa5847ee1df642a0e48d6e6913ca40438a85432f"
    sha256                               arm64_ventura:  "2af348f32f5b77bc13aa4ecdd6476018e830827d180402a4f7fb5f7c5d8d9415"
    sha256                               arm64_monterey: "7931d8bf23a679832317022965bd5cfcbe07530bb8dc0492a9225eca1e2cd69f"
    sha256                               sonoma:         "b873c91404c682d7fff6d3026bc667d20527935dc7258a7fe4271f450068158c"
    sha256                               ventura:        "78ebc9f0f30d06bfa1a299d8ca38e85b3c73f70b22f48eb7d00fa5873d4cb3fc"
    sha256                               monterey:       "d7b3bd22637b1999089d26dfb4292c448f41e924a24adcb6479ce4294dc163b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2766d30d5ca486b3dfe2cff60c54d085c0788f89d0a0c6ab7eb910fe22d512ca"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}mongosh \"mongodb:0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}mongosh --smokeTests 2>&1")
  end
end