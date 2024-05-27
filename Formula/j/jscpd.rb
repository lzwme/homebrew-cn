require "languagenode"

class Jscpd < Formula
  desc "Copypaste detector for programming source code"
  homepage "https:github.comkucherenkojscpd"
  url "https:registry.npmjs.orgjscpd-jscpd-4.0.1.tgz"
  sha256 "dfe6f69798d89e58accff2e47da9f7814490de107a237d114ebd33f2479594d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92e034390bc4e4a3f4cfe3380836701c537bcbed345eb5bb6425eddc4ecf4b70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8b1500d85a59b857c845d9fb1f6d8ce9730617a0d5fffaf256d9171bca3f139"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "014cdb5f0a71602eae422c39857541b84b851cf6a30cd4d814764e91b023a9f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "917fd3889d31bd65baaa80829c3dae7cb08fa51e8458a71caf9bafaa81d6f4ea"
    sha256 cellar: :any_skip_relocation, ventura:        "69d20d489e345498e0f9d68e5b5550838d4bba0ec2e93a0d9961ea0bc997c089"
    sha256 cellar: :any_skip_relocation, monterey:       "044a9caa46c164fca7ba61539531e4513e32ca433340b633cd6bee12d3d9dffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f920f3ab8d136e2713174b5288c1cfb03996104584a6c63c38a505233376857d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    test_file = testpath"test.js"
    test_file2 = testpath"test2.js"
    test_file.write <<~EOS
      console.log("Hello, world!");
    EOS
    test_file2.write <<~EOS
      console.log("Hello, brewtest!");
    EOS

    output = shell_output("#{bin}jscpd --min-lines 1 #{testpath}*.js 2>&1")
    assert_match "Found 0 clones", output

    assert_match version.to_s, shell_output("#{bin}jscpd --version")
  end
end