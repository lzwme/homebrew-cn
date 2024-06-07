require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.18.0.tgz"
  sha256 "c111e029b44345381b32ed91082288e396e7bb6da6d6bf552d514991c2bf325f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b05120922e05ff14d7587a145a66e41975b39db5fb25f8cbacce0dd5bb60c4f0"
    sha256 cellar: :any,                 arm64_ventura:  "b05120922e05ff14d7587a145a66e41975b39db5fb25f8cbacce0dd5bb60c4f0"
    sha256 cellar: :any,                 arm64_monterey: "b05120922e05ff14d7587a145a66e41975b39db5fb25f8cbacce0dd5bb60c4f0"
    sha256 cellar: :any,                 sonoma:         "47af7a44a171bf24a1d726cc170218c143a2f0f8d5bd00767150c5f92249e405"
    sha256 cellar: :any,                 ventura:        "47af7a44a171bf24a1d726cc170218c143a2f0f8d5bd00767150c5f92249e405"
    sha256 cellar: :any,                 monterey:       "47af7a44a171bf24a1d726cc170218c143a2f0f8d5bd00767150c5f92249e405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "168c620e08a495142edb26aee165ead4287de056a34745f23480a23a67369db8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end