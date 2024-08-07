class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https:sql.ophir.dev"
  url "https:github.comlovasoaSQLpagearchiverefstagsv0.26.0.tar.gz"
  sha256 "4196932274d275db5a11f6bb67c7a93ef7231a3608726471d07acf1dc17fb26d"
  license "MIT"
  head "https:github.comlovasoaSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f69fea6eb8c5a0311124f9cb165d86668f59f6c1188ae1c34703590b1681c405"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dde56144e354729a13467d7f4d96e23afadbceb2948b854d1b975454c159778c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87c6f4920a2160f25a71ebd518f18eeb00899b0d464f79790109b8eaa6ad3c36"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb92297bd3bb662dd951478fcacc64596c1e8191b8beaa75a65484c5debadc58"
    sha256 cellar: :any_skip_relocation, ventura:        "761ce07b5677e90e9c04dee975abe0bfeec2546fc41df5eb403853f65cf6237f"
    sha256 cellar: :any_skip_relocation, monterey:       "c408e9b727d9adb8604ac1dbf8f4cbbca2045c1ae0856938e7cad23c9fdba8ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "075179edd79cbf43824d436bcfe4a7574a43d7a2ba6128b7dda0c6bfa25e127f"
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