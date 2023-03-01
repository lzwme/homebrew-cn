class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://ghproxy.com/https://github.com/sayanarijit/xplr/archive/v0.20.2.tar.gz"
  sha256 "19e7f9d2c9644f3a88cda98cab5b1780b55df68ce3e2323555537837e6630583"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43b6163d581e8606016d3f6938b1a67350ac89cfd3815f3329ca558b794f2fd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2ce52c487186e94e1f4213fe65b96189a783d5df6c2ce1525ba5790dfeef979"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd06359cbc862e4a8bebf28b398535da881dd305d469da06fb88b7f516b6a638"
    sha256 cellar: :any_skip_relocation, ventura:        "5b28cc89aea8dae88832094f8ff7c23ffe875fa54111d7ae26455254e8ed1df8"
    sha256 cellar: :any_skip_relocation, monterey:       "e75bb2fb525fbb70e969a3004eb0c7f37c1805c789e1e5c6fbd313864350906d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ade3915ef3b1c492f44e246f12dc813c3566de68f428b80964d3120a00ace3f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fc4edc6da92eeb42db67084582c5c679b2636a497acedeca79f06f499da2981"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end
  end
end