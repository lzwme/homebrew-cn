class Csvlens < Formula
  desc "Command-line csv viewer"
  homepage "https://github.com/YS-L/csvlens"
  url "https://ghfast.top/https://github.com/YS-L/csvlens/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "4e759823b8df1d03b0a1e0202e6b300d1a99eea6898cfdf827accb89f1547b65"
  license "MIT"
  head "https://github.com/YS-L/csvlens.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d45497892d5a4dfda3e556a75d1c04654d711fc31bfd1e7248634c6b45e069bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "068159ffd0035defaa8cef9089da8ab9a6793b42e49144d58a1028987c188b1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "678929ed5c012104d567b3a781c9116ebb084cfa48fa65b5b4ede802021e63aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "11df833e3fad752c933a8adfe15f1b12f2017491581db3ee5cd8e5856ac4e5e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "059260a6c9fbb73e0585a3f5ec3427f5b9b6d1a17844c0a3920683520f6ad2e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "135a918240e82dc0312388b386c65c245c26bc1bf3cfde49aad97b8da6c8049b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"
    (testpath/"test.csv").write("A,B,C\n100,42,300")
    PTY.spawn(bin/"csvlens", "#{testpath}/test.csv", "--echo-column", "B") do |r, w, _pid|
      r.winsize = [10, 10]
      sleep 5
      # Select the column B by pressing enter. The answer 42 should be printed out.
      w.write "\r"
      assert r.read.end_with?("42\r\n")
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end