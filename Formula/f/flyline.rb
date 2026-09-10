class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://ghfast.top/https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "9cd8bf72365cf88a76a46ac7f3fc90c6377ec5667ae9434b442fb7b300ab2e5e"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a4cbb3e7da4f542ead5e3d59cee81b9688bb1155ca59497027c456a31208bbff"
    sha256 cellar: :any, arm64_sequoia: "4c3e5bd746f6a9b2ae1528f03653637615c5b0c3aeb67ea748bc79f582b03827"
    sha256 cellar: :any, arm64_sonoma:  "5f4e819931f41e8b7375f83c1b7ec0f67d5cfab4cea3c84ab3469481f50c5317"
    sha256 cellar: :any, arm64_linux:   "6961edc2e30d740913af11c388c5f60a3166d6f6bab6b00d1f73fa821961faaf"
    sha256 cellar: :any, x86_64_linux:  "d9e9f3be418c845fb3153c790920ee34dcc5cdcc4b4818d21ddcb7e7046a2c6f"
  end

  depends_on "rust" => :build
  depends_on "bash" => :test

  def install
    cargo_args = std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] }
    system "cargo", "build", "--lib", "--release", *cargo_args
    (lib/"bash").install shared_library("target/release/libflyline") => "flyline"
  end

  test do
    require "io/console"
    require "pty"

    output_log = testpath/"output.log"
    PTY.spawn(formula_opt_bin("bash")/"bash", "--noprofile", "--norc", "-i",
              [:out, :err] => output_log.to_s) do |r, w, pid|
      r.winsize = [80, 130]
      w.puts "enable flyline"
      w.puts "flyline version"
      w.puts "flyline changelog"
      w.puts "exit"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end

    output = output_log.read
    assert_match "Changelog", output
    assert_match version.to_s, output
  end
end