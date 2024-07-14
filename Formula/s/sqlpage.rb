class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https:sql.ophir.dev"
  url "https:github.comlovasoaSQLpagearchiverefstagsv0.25.0.tar.gz"
  sha256 "4ddcc00fff4151865185767f537e7949120f8786588e03c7116859ad39382340"
  license "MIT"
  head "https:github.comlovasoaSQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d973e11123a23b16c50ed6a39dcda50b333fb35891f2907088444f25611eb9e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "960ba4d1c40819a0c51d3c62577561433960e6cf5a1ff75c37e755686c3ef627"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13f37afa90e50ab1bb673c185df7ed7e632b00032dcaad8729a945ea606a6e9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbca7bfbbb7dd845cab95fa94ae5c346a21ade775a1e887ccfd37582d92c9ec7"
    sha256 cellar: :any_skip_relocation, ventura:        "6d005e5870f5f920cef3633c8fe2b9606db84b4acef954814f401f4af9969761"
    sha256 cellar: :any_skip_relocation, monterey:       "ea76936f11fc2068e30638a86c91443701f46cdf75ed22e06fcb32be424832e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a76e643eb69f4b72224ae3ee440b827a9f19020d3d6b531c31ee4aa8c499ebd"
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