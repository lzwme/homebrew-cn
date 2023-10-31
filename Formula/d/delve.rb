class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://ghproxy.com/https://github.com/go-delve/delve/archive/refs/tags/v1.21.2.tar.gz"
  sha256 "41f104a562d79fa47aa025b5f94e1302279805c148c0e57fd3ed3ae075656bb5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1f2de05bd6654d6120492f5accbab1d78113d79f4c1b46472ac63941f0b830a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1994c682760213d4f08c4ad0f165970e77c520f3a92fd4a503f580dcc19f5f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4155d0dd64b83c5a8453543ce8a705eb59b93acc1bb3004f010bfa759e4dba9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d302ce3d47d4741300e4d0723e94fd0a79e260ae9f8b9c6442456c02ed872cfb"
    sha256 cellar: :any_skip_relocation, ventura:        "c6a06dd852f4d3859d0ff7b5663b76956af65116bdf904590f84d186758c1a53"
    sha256 cellar: :any_skip_relocation, monterey:       "e800c22dfdbd121204b2de5b71cc4fdcdcc82ab559a36143052cd0e2867729a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7479862443bc6bc80572a07dbc03aba2f9edc6ce333ce404bfe8a618c726c81"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end