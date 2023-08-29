class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "3d0dd4fa4cb46651ca6f4ee400ead20ce12090f2bb88c91328d21c42c7af5352"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6ed43018e3bd2a985837108569354688a7f9e896128aaa5296870db4fc62251"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c0d2d68b0765d2876fbd34701e2f830eaed283634dcc1145b94cb5acd5b715f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b68ededecce3a728d96cf1873813756deba410e6761b3a48d79fe69419967ca"
    sha256 cellar: :any_skip_relocation, ventura:        "8bd70e3a229911f30c3b50fe2c711316138fa40a63d031f67f4f62c241b67c50"
    sha256 cellar: :any_skip_relocation, monterey:       "73cb9c31ba6825f9daec1efff9fafc14230e25376a7535db350dfebeca3e92c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2decda7fd0221b05ea285416e6d142334b426b105c197ae3ddf9d741cc12f746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8e9456b5edfb5e172a29d47213b585d56c0a8637f7c5b02363b82a912e6975b"
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
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end