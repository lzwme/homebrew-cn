class FzfMake < Formula
  desc "Fuzzy finder with preview window for make, pnpm, & yarn"
  homepage "https:github.comkyu08fzf-make"
  url "https:github.comkyu08fzf-makearchiverefstagsv0.53.0.tar.gz"
  sha256 "7f2efbfadbf05cd92d09d64f296621757291b798b372f72335fae6c0dd9c156b"
  license "MIT"
  head "https:github.comkyu08fzf-make.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18060803254eb1d10e1318ec5efc314ac1379c973af3a18e2d84ca67914fd8e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16bad69eefdcc2eba00f93f18f235d3f427269f5ed2f73173cbd2b6613711acc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db694b111ab497ee674f26d928772eef489e5c931360b6847af67c7582b3befe"
    sha256 cellar: :any_skip_relocation, sonoma:        "12ca6d1e963e0dc81298043b0dd4e99ddf6a2357bac7201b4515c5cc8a54c4b2"
    sha256 cellar: :any_skip_relocation, ventura:       "d9eef07a826f7eb822ebec07ef636340b770c2cc191f27bbbb3769e01e2fdc24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cebfc1daf9e5a416031108a7a0200174bbf876e3454351f7706bb9022a530d2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fzf-make -v")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath"Makefile").write <<~MAKE
      brew:
        cc test.c -o test
    MAKE

    begin
      output_log = testpath"output.log"
      pid = spawn bin"fzf-make", [:out, :err] => output_log.to_s
      sleep 5
      sleep 5 if OS.mac? && Hardware::CPU.intel?
      assert_match "make brew", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end