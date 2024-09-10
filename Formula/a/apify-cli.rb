class ApifyCli < Formula
  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.7.tgz"
  sha256 "0a552a078cbcf2070da5443d03f6fdf5096ebe03982b1bd7790994b4287c8270"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a658186b5bdfb8c8142add48ddf1d4eafc5449a46b5e99933e75801f1f70909a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a658186b5bdfb8c8142add48ddf1d4eafc5449a46b5e99933e75801f1f70909a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a658186b5bdfb8c8142add48ddf1d4eafc5449a46b5e99933e75801f1f70909a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6be445a36cae75f11e22da516a3806bf98176b8917b7838d86f806e307759b5c"
    sha256 cellar: :any_skip_relocation, ventura:        "6be445a36cae75f11e22da516a3806bf98176b8917b7838d86f806e307759b5c"
    sha256 cellar: :any_skip_relocation, monterey:       "6be445a36cae75f11e22da516a3806bf98176b8917b7838d86f806e307759b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "869d29eec1f7e661aaaa9a6d3de27267a127000d0002dc27e54ac1fca02b2917"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_predicate testpath/"storage/key_value_stores/default/INPUT.json", :exist?

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end