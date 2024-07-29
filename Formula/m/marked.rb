require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-13.0.3.tgz"
  sha256 "d70b051b88307eea37ccccae7d3eed9bc6c1adac58b7d616afe26731f44d2b05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4089a73f052ccaa79fd20cefca6132843a85e8b5a06a386516f9bc0c6807f21d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4089a73f052ccaa79fd20cefca6132843a85e8b5a06a386516f9bc0c6807f21d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4089a73f052ccaa79fd20cefca6132843a85e8b5a06a386516f9bc0c6807f21d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4089a73f052ccaa79fd20cefca6132843a85e8b5a06a386516f9bc0c6807f21d"
    sha256 cellar: :any_skip_relocation, ventura:        "4089a73f052ccaa79fd20cefca6132843a85e8b5a06a386516f9bc0c6807f21d"
    sha256 cellar: :any_skip_relocation, monterey:       "4089a73f052ccaa79fd20cefca6132843a85e8b5a06a386516f9bc0c6807f21d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f006638493f31cbb476d0d38f274af181e0a57a10965f50bec3283eb112431b7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end