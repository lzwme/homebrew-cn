class Gops < Formula
  desc "Tool to list and diagnose Go processes currently running on your system"
  homepage "https://github.com/google/gops"
  url "https://ghfast.top/https://github.com/google/gops/archive/refs/tags/v0.3.28.tar.gz"
  sha256 "9a040fe38e45aa41cfc43be5babb5e7962b027e1f6f8b68e5112f01866a42bba"
  license "BSD-3-Clause"
  head "https://github.com/google/gops.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13afac20f62471389e906baee36e73ded82d21423768084f37935f56ff6bfb22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83f555aaca8cb0ff590716cffa03e86e90e1dfd8ac5606471ed225575bb7ebf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd34ef9045205ce3cda53d14b05cb9cb2a861bd6546a485beb1bbd2fd690f1cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "11c1ff7be42fe13491955d2a6f5c7a7d129cdd08de0b8f2fef7d83e254b9cc3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac5fb615419e0abaf0a025cf267c64c18c5057153709e788758c341e60689b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87de4de9b1447d8b78d423186b4b4a746bac7e076bbaf6e901fb75af3e5ceeec"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"gops", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"go.mod").write <<~GOMOD
      module github.com/Homebrew/brew-test

      go 1.18
    GOMOD

    (testpath/"main.go").write <<~GO
      package main

      import (
        "fmt"
        "time"
      )

      func main() {
        fmt.Println("testing gops")

        time.Sleep(5 * time.Second)
      }
    GO

    system "go", "build"
    pid = fork { exec "./brew-test" }
    sleep 1
    begin
      assert_match(/\d+/, shell_output(bin/"gops"))
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end