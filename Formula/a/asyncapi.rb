require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.12.1.tgz"
  sha256 "228243a194621fcf9eabb760fba4d4d792f0d5afcb4cd10b7a6ac6fa38fafc03"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e8932e53dbe80e160a4ebc6d460b6091762a00668855d8437bb4bbec2304a677"
    sha256 cellar: :any,                 arm64_ventura:  "c381d563160721be6214d7c87d85085e1a1c18329d512d615c5d9f5adfabd46a"
    sha256 cellar: :any,                 arm64_monterey: "43abd3d8352be6ebb37ef5efa006208aa866bdad7010ced1ea619581c274cfc3"
    sha256 cellar: :any,                 sonoma:         "a39fb00d6d2f2c75cca01b734c026363f92ce031b4a7f94182cc72143f480ccb"
    sha256 cellar: :any,                 ventura:        "51fa29dae9bb407f0d9085f8291eef1aa3a2f9def48bb57f40ce9b7c942d1f51"
    sha256 cellar: :any,                 monterey:       "e9bbb0a140d2dc26b58dd3ce03aaf4b0b3321d6600747a574d29279337a33945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eac978db54a4ff61ca0a60a1bc52bf81935b3714f528765561760e23b96c5537"
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