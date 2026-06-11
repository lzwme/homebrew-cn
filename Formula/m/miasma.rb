class Miasma < Formula
  desc "Trap AI web scrapers in an endless poison pit"
  homepage "https://github.com/austin-weeks/miasma"
  url "https://ghfast.top/https://github.com/austin-weeks/miasma/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "d0a568b0490d5e238f605452d29db4c582ce477d4a1e0c087b2e58d68f7b0602"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "172b3f6f5fbedbb8c6de4db648a8c8fbff3c355645c5e220bb368772dc4e42f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87e90d9af36cea1bf503d3c27a8c4d5f8af3218c03ff7b46384f066a383409ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a219517d4ab9a0ef49e330f5e399bd7ccce69a5846ace75b471a8a2173eb371"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6dcecdcb93b9ab487125e3382560a6e5e52cdadf9b668fb723d8cd111e3853c"
    sha256 cellar: :any,                 arm64_linux:   "2f001f245769bd39ed7c76fce296c09dad82520f1d1d75355ab61b493503ee82"
    sha256 cellar: :any,                 x86_64_linux:  "038b2a295b3fdd4a1842665b6d55b1b3489b20ea370b19d39e5bd61861311d87"
  end

  depends_on "rust" => :build

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = spawn bin/"miasma", "--host", "127.0.0.1", "--port", port.to_s

    # give the server a second to start up
    sleep 3
    system "curl", "-sSf", "http://127.0.0.1:#{port}/"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end