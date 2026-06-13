class Pkgsite < Formula
  desc "Documentation server for Go packages"
  homepage "https://pkg.go.dev/golang.org/x/pkgsite"
  url "https://ghfast.top/https://github.com/golang/pkgsite/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3984dfb940fda82700ec421de2f029730a6fddb89be0009efc64ea62e817b2ed"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/pkgsite.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f92de73e02ca09a0d3a859a6c3cdaaeba62732dad04fe76eac9f3de690ea7dad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92de73e02ca09a0d3a859a6c3cdaaeba62732dad04fe76eac9f3de690ea7dad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f92de73e02ca09a0d3a859a6c3cdaaeba62732dad04fe76eac9f3de690ea7dad"
    sha256 cellar: :any_skip_relocation, sonoma:        "204b1d2578cbe197d524ac32190d3ddc108dadb1b2bdb86698ea097c1a05fc12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e0e4dd2f54190a3d34a76ebec736d89a56c49aa828e93c330fc593bae4c1cb8"
    sha256 cellar: :any,                 x86_64_linux:  "c1a83ddfd2b0d09df02d15f25817ac95ff5087e6065a15d3fc6bf2c330d64e0f"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pkgsite"
  end

  test do
    require "socket"
    require "timeout"

    port = free_port

    testmod_path = testpath/"testmod"
    testmod_path.mkpath

    (testmod_path/"go.mod").write <<~MOD
      module example.com/testmod

      go 1.26
    MOD

    (testmod_path/"main.go").write <<~GO
      package main

      func Hello() string { return "hi" }
    GO

    pid = spawn bin/"pkgsite", "-http", "127.0.0.1:#{port}", "-cache", testmod_path

    Timeout.timeout(60) do
      loop do
        TCPSocket.new("127.0.0.1", port).close
        break
      rescue Errno::ECONNREFUSED
        sleep 0.2
      end
    end

    raise "pkgsite exited unexpectedly" if Process.waitpid(pid, Process::WNOHANG)

    package_output = shell_output("curl -s http://127.0.0.1:#{port}/v1beta/package/example.com/testmod")
    assert_match '"modulePath":"example.com/testmod"', package_output

    symbols_output = shell_output("curl -s http://127.0.0.1:#{port}/v1beta/symbols/example.com/testmod")
    assert_match '"name":"Hello"', symbols_output
    assert_match '"kind":"Function"', symbols_output
    assert_match "func Hello() string", symbols_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end