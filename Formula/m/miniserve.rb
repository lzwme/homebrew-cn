class Miniserve < Formula
  desc "High performance static file server"
  homepage "https:github.comsvenstarominiserve"
  url "https:github.comsvenstarominiservearchiverefstagsv0.25.0.tar.gz"
  sha256 "27986ea4f3ba6670798e6c78709b7c11d5bbd1417b93826123e829c40b5bd000"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1347232782034a0872c04bf07828f830dfc8aa41ae3901942d87f065e426a59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1daa2498764836229e1d2d26cdfd220c93620627755d5dfc042ac8f9d71f51f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2e37b88ae92df00824570b2d33a806699555b5fa72f0d1a2c603b78f7dc5b6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3cc9cb1b1535b42147c247485ef15e4ef7f4831ecbda382621914bca9114b61"
    sha256 cellar: :any_skip_relocation, ventura:        "7ed067196d1ecded600166050ed651a90d86e83b081a52da89ccd2fcdc6b7c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "53f375aaf486130af584be7d62d0492a4a239c22a4e7e90bc17ddf0978751218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0acfcd885701a5cc72ed0675cb1869714ca4ad3d172e63c46ea8a83884a690e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"miniserve", "--print-completions")
    (man1"miniserve.1").write Utils.safe_popen_read(bin"miniserve", "--print-manpage")
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}miniserve", "#{bin}miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end