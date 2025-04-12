class GoMd2man < Formula
  desc "Converts markdown into roff (man pages)"
  homepage "https:github.comcpuguy83go-md2man"
  url "https:github.comcpuguy83go-md2manarchiverefstagsv2.0.6.tar.gz"
  sha256 "5fa29154237bc840a10a06231c066f9ddbe06bb31d1c3372eab12e1ed977271f"
  license "MIT"
  head "https:github.comcpuguy83go-md2man.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "386385f734e6980cd796ef8c730ce0a24cda6258d62583f63adbb4770b5a246c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "386385f734e6980cd796ef8c730ce0a24cda6258d62583f63adbb4770b5a246c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "386385f734e6980cd796ef8c730ce0a24cda6258d62583f63adbb4770b5a246c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f403e810b84edebc51c4f8e23f6a9f944e7259df273976f8bce39c0f2bf704f"
    sha256 cellar: :any_skip_relocation, ventura:       "3f403e810b84edebc51c4f8e23f6a9f944e7259df273976f8bce39c0f2bf704f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "899178bcab4903339128975a40bd8b5342f55036fab9db92bdcce8ea52765fa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b560a2b606a1bb4065ec10a33dad917042b3cbd182e5bd900434d9555135b5cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    system bin"go-md2man", "-in=go-md2man.1.md", "-out=go-md2man.1"
    man1.install "go-md2man.1"
  end

  test do
    assert_includes pipe_output(bin"go-md2man", "# manpage\nand a half\n"),
                    ".TH manpage\nand a half\n"
  end
end