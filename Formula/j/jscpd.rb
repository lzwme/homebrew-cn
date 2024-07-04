require "languagenode"

class Jscpd < Formula
  desc "Copypaste detector for programming source code"
  homepage "https:github.comkucherenkojscpd"
  url "https:registry.npmjs.orgjscpd-jscpd-4.0.5.tgz"
  sha256 "e284fc35166ee0cd5f0db3d5c15b8e9bf8bbc2914d498f361c65e259cf15ae67"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8abada5224d18bacad2a11a48c0b7efaa8fc198556660193a193489a63d1e5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8abada5224d18bacad2a11a48c0b7efaa8fc198556660193a193489a63d1e5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8abada5224d18bacad2a11a48c0b7efaa8fc198556660193a193489a63d1e5c"
    sha256 cellar: :any_skip_relocation, sonoma:         "70d55d47a1144b062afa4812ff066830148fc314c33b1b55b1f8ea2d5adfd6b5"
    sha256 cellar: :any_skip_relocation, ventura:        "70d55d47a1144b062afa4812ff066830148fc314c33b1b55b1f8ea2d5adfd6b5"
    sha256 cellar: :any_skip_relocation, monterey:       "70d55d47a1144b062afa4812ff066830148fc314c33b1b55b1f8ea2d5adfd6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a05371abbe1efa2d0331af9bdcf74bbe1daad9cc91a0ddb329cbf8b242266428"
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