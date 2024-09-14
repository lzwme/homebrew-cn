class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https:sql.ophir.dev"
  url "https:github.comlovasoaSQLpagearchiverefstagsv0.28.0.tar.gz"
  sha256 "8cd1e03e37a7eb905bebeffb4c1e2dc5cb4cfc74510ecd6d4cff203e0b597ea7"
  license "MIT"
  head "https:github.comlovasoaSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8be827e8708deb4c51a7ba37d4483be061e457ac8f9d39d9a702f43a92f951ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eec506860c2e78391ce78b5cee284c8755863015279aa76ab4a39dad49d6250c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38d549837406e8231eda9e55d10f9becda3e466c85bc025876539d362a3e9eb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd0ada889fb6308120d3c90355b22fff0a46a08cf790cbe0e9e3a629c4daebf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "46fa11f2fc5f50f45e3ffea9f00d7b66625c9bb8f566ed9bb2bbc96ffb987a47"
    sha256 cellar: :any_skip_relocation, ventura:        "46c4f999b590bb06790fb25d5478b7ead868c34e38cadc69a2b05bc471cbb85a"
    sha256 cellar: :any_skip_relocation, monterey:       "70adffbe85690853a8850cedf5ac5c3552ef9269916f1888d8539cc273e272c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "515ffaa736f1ca9692e13833b5c54af532ce0c73e2369a2b4778398b7324c607"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http:localhost:#{port}")
    Process.kill(9, pid)
  end
end