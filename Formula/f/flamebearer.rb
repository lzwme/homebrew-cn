require "languagenode"

class Flamebearer < Formula
  desc "Blazing fast flame graph tool for V8 and Node"
  homepage "https:github.commapboxflamebearer"
  url "https:registry.npmjs.orgflamebearer-flamebearer-1.1.3.tgz"
  sha256 "e787b71204f546f79360fd103197bc7b68fb07dbe2de3a3632a3923428e2f5f1"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ad02e0d6540676b243b163cd8b8e553fa010af1b5024f7892a24e5d013b677e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89daa7227623f6360bcb55918d32fa3c783a0e9404efebd84d170fb614108642"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c58234912fa727a85aa1f072c14a7fd49aae68ff6023325baf045ddec3b7c3a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c58234912fa727a85aa1f072c14a7fd49aae68ff6023325baf045ddec3b7c3a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e23a97d02b0da2e8b5c30844796a4db3808b1d9c0668278161e0c3fff196a399"
    sha256 cellar: :any_skip_relocation, ventura:        "c768be35f9497cc095ad4f1329cdcc3e7ffafad8f287dcf406cfa7090ac6daba"
    sha256 cellar: :any_skip_relocation, monterey:       "98988646062bd8230583e9bbb7cad33fadcde48cae70d92a6011580494cc84f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "98988646062bd8230583e9bbb7cad33fadcde48cae70d92a6011580494cc84f6"
    sha256 cellar: :any_skip_relocation, catalina:       "98988646062bd8230583e9bbb7cad33fadcde48cae70d92a6011580494cc84f6"
    sha256 cellar: :any_skip_relocation, mojave:         "98988646062bd8230583e9bbb7cad33fadcde48cae70d92a6011580494cc84f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c58234912fa727a85aa1f072c14a7fd49aae68ff6023325baf045ddec3b7c3a1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"app.js").write "console.log('hello');"
    system Formula["node"].bin"node", "--prof", testpath"app.js"
    logs = testpath.glob("isolate*.log")

    assert_match "Processed V8 log",
      pipe_output(
        "#{bin}flamebearer",
        shell_output("#{Formula["node"].bin}node --prof-process --preprocess -j #{logs.join(" ")}"),
      )

    assert_predicate testpath"flamegraph.html", :exist?
  end
end