class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.16.2.tgz"
  sha256 "f9a016d4874e846d7273b6c3ce7f794f3b1eaeca8b09ae0b70945a98a21c8feb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82de7ea48d83dc2a7539875926a249d03b3c79b1cd1d896cf099eefee9a8ea4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82de7ea48d83dc2a7539875926a249d03b3c79b1cd1d896cf099eefee9a8ea4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82de7ea48d83dc2a7539875926a249d03b3c79b1cd1d896cf099eefee9a8ea4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "38083d42b679cd765d4e9e11c349e0d0edc19bd6dbeaf53ebe2a958cf57ac7c3"
    sha256 cellar: :any_skip_relocation, ventura:       "38083d42b679cd765d4e9e11c349e0d0edc19bd6dbeaf53ebe2a958cf57ac7c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82de7ea48d83dc2a7539875926a249d03b3c79b1cd1d896cf099eefee9a8ea4c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end