class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://ghfast.top/https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "42893aed49f5172cc61a6c7d1dbdca11eacbe8c1a9a783a993ae841b45d78e42"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ef4fc20590ccea3c8a5045e2a858620192e443046282bbc92322d6a056335e0a"
    sha256 cellar: :any, arm64_sequoia: "e310f91b5d998e0e35ffbfb5ea970798faea8300321f920d04caceed8d621617"
    sha256 cellar: :any, arm64_sonoma:  "7564aac8df207814f740a46fab6cfce80b07ba3d1e8ad539457a2c1341cbe90a"
    sha256 cellar: :any, sonoma:        "c082f9f0797355f198a72bd6eb4b9f5596bc89dc60258e3469b753f18fe2479e"
    sha256 cellar: :any, arm64_linux:   "f00a6c12ab2d4e7b88bd060ddd9798d81f2cb347f6b86cddc5cb2a9e64a910f3"
    sha256 cellar: :any, x86_64_linux:  "eba125c5fb0fc6dd51a50979df8f865c69d28451d7a00b19deccb03b02197ea1"
  end

  depends_on "rust" => :build
  depends_on "bash" => :test

  def install
    cargo_args = std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] }
    system "cargo", "build", "--lib", "--release", *cargo_args
    (lib/"bash").install shared_library("target/release/libflyline") => "flyline"
  end

  test do
    Open3.popen2("script", "-q", "screenlog.txt") do |input, _, thr|
      input.puts "#{formula_opt_bin("bash")}/bash -il"
      sleep 5
      input.puts "stty rows 80 cols 130"
      input.puts "export LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm"
      input.puts "enable flyline"
      sleep 2
      input.puts "flyline changelog | grep -F 1.3.0"
      sleep 2
      input.puts "exit"
      sleep 5
      input.close
    ensure
      Process.kill("TERM", thr.pid)
    end

    screenlog = (testpath/"screenlog.txt").binread
    # Match the tooltip that should be displayed for the last input line
    assert_match "Display the changelog", screenlog
  end
end