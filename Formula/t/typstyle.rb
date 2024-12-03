class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.6.tar.gz"
  sha256 "b04a77a9f75dda3a9513088ee3cd28f0a093ff6a977f38186427bbb0e03ce66b"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee6f99d3419fd96ad4823c93f938fa865986b9a6c097989625904ccecfa2b45d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b132ffe9982efe18c35d463cf7993ea3dfb03c4d94d43120561a189d31de402d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b4cce56c2894f4121f0fa7a1f2512b2b55369d68764e791b7eef2de6eee10dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "55c243e3832a497054e96f7cb6474bab56115ef340bd51015bf007bd68a5fd3a"
    sha256 cellar: :any_skip_relocation, ventura:       "360fd791ead5a1022344fc539f53c5ab4fa7bcd7bba0fc0cc104a0d3ea793c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e00796746724f4c52866cad49d140e2903858677562053600625290758475eb6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end