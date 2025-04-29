class IsFast < Formula
  desc "Check the internet as fast as possible"
  homepage "https:github.comMagic-JDis-fast"
  url "https:github.comMagic-JDis-fastarchiverefstagsv0.16.1.tar.gz"
  sha256 "6a4586cf80dccb2e6df03711196c476885f69d24d72de8eca61ee01d78b51f2e"
  license "MIT"
  head "https:github.comMagic-JDis-fast.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "547c85e507f5dffe0092465d43a3b47c29693a386cbb3be63cc6f103e86fadfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b15e2a29c7893d5088686ae1934d67dfedacabe84e1a1a65f05923ef076283fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4b581f71bef91eb79dcf7d3849da90ec69a42b699d2e12eb818bfcba9971b4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a92ef6fdfb42b629b78a2ec0b66f077a93edeb78320ae1a652533c6f19691d7d"
    sha256 cellar: :any_skip_relocation, ventura:       "de271cb36a1bc4ca4eb7b5d46b597e8106841f572f8df571ef7db144504d830d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aa1b494b55910226ed2e4e8ccb4ed7be0fe69df7baa8536a9afdd27ef6296b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b58ed7faecd3547cded343945e9e10ebd56b19cb735e96d62a2f83b71b74c4f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "is-fast #{version}", shell_output("#{bin}is-fast --version")

    (testpath"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head><title>Test HTML page<title><head>
        <body>
          <p>Hello Homebrew!<p>
        <body>
      <html>
    HTML

    assert_match "Hello Homebrew!", shell_output("#{bin}is-fast --piped --file #{testpath}test.html")
  end
end