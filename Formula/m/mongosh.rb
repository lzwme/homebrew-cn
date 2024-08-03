class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.2.15.tgz"
  sha256 "544bb681fb419d83bd4e6b00bcd7ccebd0922cc84dfa7c86fb9f64c65dc9c049"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256                               arm64_sonoma:   "e3f40fb59b554d89e5c672bede9d3ecfc2556ffa1300bb225ccfe70dc2545547"
    sha256                               arm64_ventura:  "0e3e42bc45f5a8ae6b92c3dfd86e763e172bf193188104dd2d619f08e9e0bd58"
    sha256                               arm64_monterey: "6bd6dfaef251caf2be2207e2f72618f06f7d386f094c8ca2b3ea59e580312236"
    sha256                               sonoma:         "709211ff5a166f97d561a69fa84249198fd1fd6df238c4b3645dc837c3ceb761"
    sha256                               ventura:        "918f8fba8ff250bc2092465a889a1ca7851d27dc3c52ebfaba364d7161d8b83a"
    sha256                               monterey:       "ea1c67a938f8a6116fc7b43e1f041af108edac9784a222c9580387c18cb103e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8829a24d8188f6655278791d3f722e05a02652a7e81943e101035460bd584825"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}mongosh \"mongodb:0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}mongosh --smokeTests 2>&1")
  end
end