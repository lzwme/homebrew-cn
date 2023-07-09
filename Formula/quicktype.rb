require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.54.tgz"
  sha256 "308b1d307ecf3492e5e3e543578bb3898b98764aa179c8e644b1fe97558b1b46"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f1b82cd848c260a9896c26901cb4a4139033ca71a3db6b43cdca185ef8e8020"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f1b82cd848c260a9896c26901cb4a4139033ca71a3db6b43cdca185ef8e8020"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f1b82cd848c260a9896c26901cb4a4139033ca71a3db6b43cdca185ef8e8020"
    sha256 cellar: :any_skip_relocation, ventura:        "e10220439a644d4e2cefc8e3bfb33d207b47dea36f686efdc58f777cbfdd11f4"
    sha256 cellar: :any_skip_relocation, monterey:       "e10220439a644d4e2cefc8e3bfb33d207b47dea36f686efdc58f777cbfdd11f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e10220439a644d4e2cefc8e3bfb33d207b47dea36f686efdc58f777cbfdd11f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f1b82cd848c260a9896c26901cb4a4139033ca71a3db6b43cdca185ef8e8020"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
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