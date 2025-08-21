class Otree < Formula
  desc "Command-line tool to view objects (JSON/YAML/TOML) in TUI tree widget"
  homepage "https://github.com/fioncat/otree"
  url "https://ghfast.top/https://github.com/fioncat/otree/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "e0fc252aef6ba27fad0243533fb0b287ba096575fca540d8a389bd1dba79e695"
  license "MIT"
  head "https://github.com/fioncat/otree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9100e71c8c55197993329bff3b78009c1b38a6178a44dc0852f9cfdd0324bffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f74f4dd69e573e2bd6c98829c187573d1705cf620a3a505664624438441f7d75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ad28c8903532ff6a878be6bc54b577a976c7ff2f3674d1082c0b9a808a8f3ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f6a6ce534200386a681c62f882123c55cf25c0081f74b4fa7fd5b455f1a9016"
    sha256 cellar: :any_skip_relocation, ventura:       "d8853611e437e350f09f58f745eabfd78475a3ca0fc54b4e617c7540270a8783"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93712b0eaafc1757990e27cac84213e0f95150a740b627c39da2021957f29fda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8445489155c87f787541e50c872c0251371a18b66d80931d2bfc161af60c54c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"example.json").write <<~JSON
      {
        "string": "Hello, World!",
        "number": 12345,
        "float": 123.45
      }
    JSON
    require "pty"
    r, w, pid = PTY.spawn("#{bin}/otree example.json")
    r.winsize = [36, 120]
    sleep 1
    w.write "q"
    begin
      output = r.read
      assert_match "Hello, World!", output
      assert_match "12345", output
      assert_match "123.45", output
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end