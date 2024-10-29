class Otree < Formula
  desc "Command-line tool to view objects (JSONYAMLTOML) in TUI tree widget"
  homepage "https:github.comfioncatotree"
  url "https:github.comfioncatotreearchiverefstagsv0.3.0.tar.gz"
  sha256 "63a63b09af2186d2bc3aa8631989f1fbdeb7659d7f1857be7fae1e0af4d42fde"
  license "MIT"
  head "https:github.comfioncatotree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "065cd405c1aece0c6b42f4634056969a3beea49263140cd5227515e3220bb0ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb70a7a0af610aeca065fb00950f4810cc1a78618c45f48c69f5ca462a330ef2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6fc182480520ba8b09966d55887ab5315e449cb1f3d4af1ead0788d2fb2c41c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ba8f2709bce3ec34adc7911c233d1c95ce34d75f8da01e2bdea3afad5ecd5f7"
    sha256 cellar: :any_skip_relocation, ventura:       "b56cc29e18911359278a7618e2a8e667433a90ebd532fe76ad4f841588a57c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95f451a551bbb740a4356ba67f43d68fa9018ccdd2bc774a5dc3e72482d3fcfc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"example.json").write <<~JSON
      {
        "string": "Hello, World!",
        "number": 12345,
        "float": 123.45
      }
    JSON
    require "pty"
    r, w, pid = PTY.spawn("#{bin}otree example.json")
    r.winsize = [36, 120]
    sleep 1
    w.write "q"
    begin
      output = r.read
      assert_match "Hello, World!", output
      assert_match "12345", output
      assert_match "123.45", output
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end