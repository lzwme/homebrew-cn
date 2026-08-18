class Flyline < Formula
  desc "Supercharged Bash plugin replacement for readline"
  homepage "https://github.com/HalFrgrd/flyline"
  url "https://ghfast.top/https://github.com/HalFrgrd/flyline/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "de8b969ec75af2e22f62f09c28b9951706ad9fed1616bfb45dad64675922a08c"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "25210d5c1a44a74337b38196c0281c1ab69c09526e64f070c0ce75bca47cc23d"
    sha256 cellar: :any, arm64_sequoia: "43bd6f6be6674f81f1dfce2da494479f33bf45148170fb5854a1f15ce7a01c24"
    sha256 cellar: :any, arm64_sonoma:  "dc516a7864e1ea714609f2bd7918cd6e7711b2ba6973f6fe6e2e4945ee47b807"
    sha256 cellar: :any, sonoma:        "f186bdeb6647867b0d3c000cf86a1ee317e46619e1921c26ce6c9780d89646a3"
    sha256 cellar: :any, arm64_linux:   "de45b19f5a6814988a4cda08e9e49807bc792db4122f87a93a53ef0896987f68"
    sha256 cellar: :any, x86_64_linux:  "f787cdf60b550eac1d3d3cce420d938c5ba62462fb3cbc0ba0decb0cffd3ed16"
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