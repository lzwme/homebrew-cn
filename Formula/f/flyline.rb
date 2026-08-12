class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://ghfast.top/https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "9bcacde196d9b46550c1b87605e8ef30c6bdf907d4a0816bf6f9348b57645cc6"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f1b7d1976a96a59813b34265bd06ede1780c0733456bede22796c3690f52d9b3"
    sha256 cellar: :any, arm64_sequoia: "f5e4dccd5d2e907235e04e5fc833eb0c6a85644a527ef8fee2fa3095dc0dc294"
    sha256 cellar: :any, arm64_sonoma:  "a0aa20bb22b5513872b51d7af7201650e067252b37751caf7021f691194ff417"
    sha256 cellar: :any, sonoma:        "5098891ea963742e09900b8d486cdebc5266769353902116bbb361b294cfa1e5"
    sha256 cellar: :any, arm64_linux:   "c33748194a5dd81b984bb535b738e65ef6fd13d00d349b21063d1c867c6da20a"
    sha256 cellar: :any, x86_64_linux:  "099fc2f460ba33f48b31e7455aba824b07b017a8ee8e389e7fbca89016f5d568"
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
    assert_match "# Changelog", output
    assert_match version.to_s, output
  end
end