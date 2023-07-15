require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.17.3.tgz"
  sha256 "24a29d160e50e2b5b0cc90524bb40d2a6cdba79c79c72698d004963506aaa7c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb1bc190d7f399df986db32dbbaf1582c66a6c0e3a8106db73069b2f09635761"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb1bc190d7f399df986db32dbbaf1582c66a6c0e3a8106db73069b2f09635761"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb1bc190d7f399df986db32dbbaf1582c66a6c0e3a8106db73069b2f09635761"
    sha256 cellar: :any_skip_relocation, ventura:        "0c5dbce3619988fa7aa9edbf762cfee3650a5c1426fca01a34e7be5043b94431"
    sha256 cellar: :any_skip_relocation, monterey:       "0c5dbce3619988fa7aa9edbf762cfee3650a5c1426fca01a34e7be5043b94431"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c5dbce3619988fa7aa9edbf762cfee3650a5c1426fca01a34e7be5043b94431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb1bc190d7f399df986db32dbbaf1582c66a6c0e3a8106db73069b2f09635761"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed,", output)
  end
end