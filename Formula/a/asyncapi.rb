class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.12.0.tgz"
  sha256 "b46d4159df43e630903d8d58986234b3db07f1484fd14f9ae36f46c2ecf48072"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "04f4deb8fbe3479374e0653b043694de43caf7e6a0a50fcc605b21e0b91e5c7a"
    sha256 cellar: :any,                 arm64_sonoma:  "04f4deb8fbe3479374e0653b043694de43caf7e6a0a50fcc605b21e0b91e5c7a"
    sha256 cellar: :any,                 arm64_ventura: "04f4deb8fbe3479374e0653b043694de43caf7e6a0a50fcc605b21e0b91e5c7a"
    sha256 cellar: :any,                 sonoma:        "449b94bb120f749ce5e3076dceb632d59693bba64d90c5260f379f441b664340"
    sha256 cellar: :any,                 ventura:       "449b94bb120f749ce5e3076dceb632d59693bba64d90c5260f379f441b664340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f21c2b05cb0989afd990aef1c56c5665b8692948f91934e89ad52c9562431dfb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end