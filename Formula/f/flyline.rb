class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://ghfast.top/https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "26b78ead85fd772d92396301e535b2557a97a0a469f41362bd673528bd73508b"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ea75f1480b560ca941b0f4aacc99e6311ee69a6843a6bafe0a515650e5156d2c"
    sha256 cellar: :any, arm64_sequoia: "21d2beb0f04a2d21dfff0e303c55be45c630f7d25c9db4e257a685574dcc3d71"
    sha256 cellar: :any, arm64_sonoma:  "b222679a00e99b8e39823feeb2f6f2a4c82655ac1c00c5b08ee751008fba880e"
    sha256 cellar: :any, sonoma:        "b25e1042e3788939dab95da4696f2cae21102daa037c2811ce64f66c2e3d6d3b"
    sha256 cellar: :any, arm64_linux:   "74a245f4311d39fadda607b0fb63f3e0d38174e59dac3e11e61d793c84c78e35"
    sha256 cellar: :any, x86_64_linux:  "8b80e5746f6c1462aa0b2b1f661942352a629ec58a3b8cce64019634b2b60ba0"
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