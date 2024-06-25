require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-13.0.1.tgz"
  sha256 "fe242fab365db4d7dc5989d7c7e517a270a6f66ac52ba154790eb5739a5c9392"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee0f24912e30f055e49577e000f826b38e3b748c366c5b3d61bcc927e9d25b28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee0f24912e30f055e49577e000f826b38e3b748c366c5b3d61bcc927e9d25b28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee0f24912e30f055e49577e000f826b38e3b748c366c5b3d61bcc927e9d25b28"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee0f24912e30f055e49577e000f826b38e3b748c366c5b3d61bcc927e9d25b28"
    sha256 cellar: :any_skip_relocation, ventura:        "ee0f24912e30f055e49577e000f826b38e3b748c366c5b3d61bcc927e9d25b28"
    sha256 cellar: :any_skip_relocation, monterey:       "ee0f24912e30f055e49577e000f826b38e3b748c366c5b3d61bcc927e9d25b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b30d86b5c555688be3c1c4e7fa43de04bcce66fa421a89f9b79778f79f6c639b"
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