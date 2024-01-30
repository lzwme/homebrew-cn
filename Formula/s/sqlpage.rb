class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https:sql.ophir.dev"
  url "https:github.comlovasoaSQLpagearchiverefstagsv0.18.2.tar.gz"
  sha256 "af3c0e6259dedbf31d9f68f2644b4a1c65b354dbf2e38682b5ad458af2b8585a"
  license "MIT"
  head "https:github.comlovasoaSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad868d6abf33b4b65a3f037b8f14f98cc1df099e37064e780ee3d731b9701174"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df0a5bd7b5250484e807de7f989f275404b99cf3bba8d196e3d298b752a2fc14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4295538918d0042ebb77d772c975ce68ee830e4a4b3e854a871b94b9090c1e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "0cb78b972358d823e9d856fdaf876a68daa6afdc358e5647a47eec3c355f07db"
    sha256 cellar: :any_skip_relocation, ventura:        "f20ba4780bb383a490990ba8106cda3924400f6a77d42e0f6dddfb75b2d15897"
    sha256 cellar: :any_skip_relocation, monterey:       "a9f52f1fffba9bc926c650c70398ebedac6ddb51f0f5365881da922469033145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994f761b33320434825575aa53511a0cabda32462c1012702cf66394e44261b7"
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