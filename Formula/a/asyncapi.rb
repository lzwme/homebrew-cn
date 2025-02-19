class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.16.5.tgz"
  sha256 "ec55e2822f993508819d549de96416d301ce13ad409702a55e5da8f55121bf3a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0413c3d40c321124d0e8f319051833f494c1225491a0e6569df6f0971c61bdda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0413c3d40c321124d0e8f319051833f494c1225491a0e6569df6f0971c61bdda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0413c3d40c321124d0e8f319051833f494c1225491a0e6569df6f0971c61bdda"
    sha256 cellar: :any_skip_relocation, sonoma:        "266c7d6b76a47abb4fa7d2060257d75ea9043bc8ce2770b19b8b4d1e57e03e05"
    sha256 cellar: :any_skip_relocation, ventura:       "266c7d6b76a47abb4fa7d2060257d75ea9043bc8ce2770b19b8b4d1e57e03e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0413c3d40c321124d0e8f319051833f494c1225491a0e6569df6f0971c61bdda"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath"asyncapi.yml", "AsyncAPI file was not created"
  end
end