require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.0.79.tgz"
  sha256 "ecd8992d9a3c2087952478f49afe7f191a93e649afca3b02ed72e8fbd9027541"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9514d0dae547d8e5fccba202142370814c8db9d65558a000115d0f0b95377568"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9514d0dae547d8e5fccba202142370814c8db9d65558a000115d0f0b95377568"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9514d0dae547d8e5fccba202142370814c8db9d65558a000115d0f0b95377568"
    sha256 cellar: :any_skip_relocation, sonoma:         "22166cb52e3e2efbcc813014ca8044a9d69a42e9031911b3d1c224552e1667e4"
    sha256 cellar: :any_skip_relocation, ventura:        "22166cb52e3e2efbcc813014ca8044a9d69a42e9031911b3d1c224552e1667e4"
    sha256 cellar: :any_skip_relocation, monterey:       "22166cb52e3e2efbcc813014ca8044a9d69a42e9031911b3d1c224552e1667e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9514d0dae547d8e5fccba202142370814c8db9d65558a000115d0f0b95377568"
  end

  depends_on "node"

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