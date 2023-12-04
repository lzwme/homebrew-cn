class Stuffbin < Formula
  desc "Compress and embed static files and assets into Go binaries"
  homepage "https://github.com/knadh/stuffbin"
  url "https://ghproxy.com/https://github.com/knadh/stuffbin/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "127acd259b6b79786ee6551ae11e46924766115130812a2f5964f11fea21839e"
  license "MIT"
  head "https://github.com/knadh/stuffbin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1084a1cd1b67d5e75d71b08b4075cf4cf35994b7c9caf0b814f5e30a93db7def"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d15941eea0289297da196d84b3a44b30a910ebd208fe32b6bdeeef2870bd41a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "204d2ed48cc7353a962f185b555a20f2800e168c474f4e8807b73d6feb79b36b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bc5b6090d2524fed856a26ff36bb62c67eb77f03f5d3e67b0fa4515e0803145"
    sha256 cellar: :any_skip_relocation, ventura:        "2e7cf2251c372749b7fb1c49ef03f5066e35757b26ed074b4cd020de5a34bf70"
    sha256 cellar: :any_skip_relocation, monterey:       "448a84eb96c9f3f663124a12313aba29ee29a3bd2de908c6352665b6e476ba7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54904a067d6226acc8ff01263f13370e0500f4a5a1ac679b57d9f67d93f4bdf7"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./stuffbin"
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      system "go", "get", "github.com/knadh/stuffbin"

      (testpath/"brewtest/foo.txt").write "brewfoo"
      (testpath/"brewtest/main.go").write <<~EOS
        package main

        import (
          "log"
          "os"

          "github.com/knadh/stuffbin"
        )

        func main() {
          path, _ := os.Executable()
          fs, _ := stuffbin.UnStuff(path)
          f, _ := fs.Get("foo.txt")
          log.Println("foo.txt =", string(f.ReadBytes()))
        }
      EOS

      system "go", "build", "."
      output = shell_output("#{bin}/stuffbin -a stuff -in brewtest -out brewtest2 foo.txt")
      assert_match "stuffing complete.", output
      assert_match "foo.txt = brewfoo", shell_output("#{testpath}/brewtest/brewtest2 2>&1")

      output = shell_output("#{bin}/stuffbin -a id -in brewtest2")
      assert_match "brewtest2: stuffbin", output
      assert_match "/foo.txt", output
    end
  end
end