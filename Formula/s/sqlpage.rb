class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://ghproxy.com/https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "864c3de3089d69073cdce048a506d8c2732a08f7ce3d04aaa976d326d02e34db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46cc0ce37a6b2780fde9cc7a6a87c32aa71c4bf04c587ab0322b18aa87fadb34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79dbeaa42801c33cd7446e621c379a43a0f3053c22ec0be96fbdc5d167144613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f097881f93d448509deee51ff4a3ad17713319b9bc467237c02fa3221ecaaacf"
    sha256 cellar: :any_skip_relocation, sonoma:         "01e9951187064e47de4b3c971f62bc8b16d97c3083bc19c5119e1467399bd7f7"
    sha256 cellar: :any_skip_relocation, ventura:        "43990bcca4b2412e8bc901fa6dc41ef0035b196efa17af47e8c99a78fe52cd47"
    sha256 cellar: :any_skip_relocation, monterey:       "6d921e6b8e23d5e6bce1a764b77dfb3b62c8521c7f86e1a2a552b4fe9cced600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d4cb905f843a3425b323c3971913861585ce925280743f47e8e976dd136cd03"
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