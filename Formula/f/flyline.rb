class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://ghfast.top/https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "f0e2dbd1d094f946b91a0015bbf3c9f6a05edf8161df8c35317e35cba47f1c12"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3959d693b6f27bfdc2065b788659f1d3f95e84c79d85a48f0c6d4c56d1015beb"
    sha256 cellar: :any, arm64_sequoia: "0966bcb19ffb9db757d8385a05f44103c2da0aec02825ff4dc1ebf9ff5a2658b"
    sha256 cellar: :any, arm64_sonoma:  "f397150fa90249cf0e673e1d7c51fbb447914ca16d31907175580336ca33ad5d"
    sha256 cellar: :any, sonoma:        "92606b74a04f83ef43798861a729eda37353db6261ca93dcf0bea3db478d7380"
    sha256 cellar: :any, arm64_linux:   "31d11db6d4cbb2eab7dee07e45ec243fb7319857a4e2143f288661d46e263a38"
    sha256 cellar: :any, x86_64_linux:  "e040ecb623b226c51ea78e6eb041fbc31cdd6ced25d4b434fd0607ac1e909c94"
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
      # The terminal backend blocks on a cursor position report for each capability it probes
      input.write "\e[1;1R" * 10
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