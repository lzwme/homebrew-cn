require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.106.tgz"
  sha256 "c88517d2f5164e17a9e193c7222892731f30345b918198476a75f6aca518d6a3"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e2b7e4e23163a22f706e50b624668f91b4af9c74d5690d7c5a68aa4cd6c38d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e2b7e4e23163a22f706e50b624668f91b4af9c74d5690d7c5a68aa4cd6c38d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e2b7e4e23163a22f706e50b624668f91b4af9c74d5690d7c5a68aa4cd6c38d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c985e9dc09e46f782d4b1ec05ea0bdd5c0357c21f76be80328562dc5c0d9b715"
    sha256 cellar: :any_skip_relocation, ventura:        "c985e9dc09e46f782d4b1ec05ea0bdd5c0357c21f76be80328562dc5c0d9b715"
    sha256 cellar: :any_skip_relocation, monterey:       "c985e9dc09e46f782d4b1ec05ea0bdd5c0357c21f76be80328562dc5c0d9b715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e2b7e4e23163a22f706e50b624668f91b4af9c74d5690d7c5a68aa4cd6c38d0"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end