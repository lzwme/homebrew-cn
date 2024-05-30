class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https:sql.ophir.dev"
  url "https:github.comlovasoaSQLpagearchiverefstagsv0.22.0.tar.gz"
  sha256 "0f64b252131bc9df3367a7754f252c0fe0533febe5fb88941861b81ae8ba57f4"
  license "MIT"
  head "https:github.comlovasoaSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f4b0c8d993d9db729a535c2129ef86ee94e3638a4869a2c93c812bcfcd5b472"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75712be88404516036b65d8f24bcc81de594cb3c773207ffde99a53e6dee52e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb6ba148c23861bbb8c455e284d834b7e204168152cf7a0078c25fe7d8635de4"
    sha256 cellar: :any_skip_relocation, sonoma:         "431dccee5733419c698450374043fa2e1d8edb68bb8df75fb0e243149c204ccf"
    sha256 cellar: :any_skip_relocation, ventura:        "3d067d3a82282b931cdc532d3a5fcfecdfa195250b2b1eb914cd068e7c87c076"
    sha256 cellar: :any_skip_relocation, monterey:       "916871cb49f25b06f3cd30a9cfe0276f27bdc8d5cf2208dbeaacee0289605f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbdab46b5943c649cc1be9c8cb2cce30eb4e6f65d5fc16c0479b89869a07066c"
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