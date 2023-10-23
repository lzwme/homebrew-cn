require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.76.tgz"
  sha256 "00cbdb63d80196669ae7fddfa17a1ad39a69db32566a92d558ea92ff6d16b821"
  license "Apache-2.0"
  revision 1
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e00c9f9da34e799fc9a850a3871a9b746f7ef546bade2131d1a7b2c1d601560b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e00c9f9da34e799fc9a850a3871a9b746f7ef546bade2131d1a7b2c1d601560b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e00c9f9da34e799fc9a850a3871a9b746f7ef546bade2131d1a7b2c1d601560b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff77eabb6fdb07d6caf308e851fbb48ddddd88615efa4d48ce02c818bc8c88c8"
    sha256 cellar: :any_skip_relocation, ventura:        "ff77eabb6fdb07d6caf308e851fbb48ddddd88615efa4d48ce02c818bc8c88c8"
    sha256 cellar: :any_skip_relocation, monterey:       "ff77eabb6fdb07d6caf308e851fbb48ddddd88615efa4d48ce02c818bc8c88c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00c9f9da34e799fc9a850a3871a9b746f7ef546bade2131d1a7b2c1d601560b"
  end

  depends_on "node@20"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV.prepend_path "PATH", Formula["node@20"].bin

    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end