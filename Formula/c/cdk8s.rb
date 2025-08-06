class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.147.tgz"
  sha256 "78b30efed7fe7440e5033230bf71ef00e3dbbbee42bd56001230d4c76f9b2225"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0740f9ff65a565b089b4149b729be5c18c985c041d58732b42599c7cd0e487d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0740f9ff65a565b089b4149b729be5c18c985c041d58732b42599c7cd0e487d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0740f9ff65a565b089b4149b729be5c18c985c041d58732b42599c7cd0e487d"
    sha256 cellar: :any_skip_relocation, sonoma:        "177f932837e22e5152af1ebd09b148ed617df7ba88f523d2ed01781c273feca8"
    sha256 cellar: :any_skip_relocation, ventura:       "177f932837e22e5152af1ebd09b148ed617df7ba88f523d2ed01781c273feca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0740f9ff65a565b089b4149b729be5c18c985c041d58732b42599c7cd0e487d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0740f9ff65a565b089b4149b729be5c18c985c041d58732b42599c7cd0e487d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end