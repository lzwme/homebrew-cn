class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https:goplus.org"
  url "https:github.comgoplusgoparchiverefstagsv1.3.6.tar.gz"
  sha256 "17d23bbc2683bdf41093f24e3b5a1f454efe43f470b1e050a243b0dc25b3a7bb"
  license "Apache-2.0"
  head "https:github.comgoplusgop.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "01cc09ea290add0c43e611a7293db540fe5b701e07e458fe743ee05ad8b5eba7"
    sha256 arm64_sonoma:  "218f47f9152d8800f538c8eb29608e02d4bb4cbfa5882061115bc11d203754ea"
    sha256 arm64_ventura: "fa6ea7dc93a69320c9b766d83e8545dbabbee5fd41447babba1bdf1896ab33b7"
    sha256 sonoma:        "2c5e93d6f512327da1a6c511bb0317c2a4934507121f777bfa175df5bbdbf80f"
    sha256 ventura:       "9006008c9c2651244df2e32e866d9bdd573d32ce5e72f1cfdfe7b23f09b47582"
    sha256 x86_64_linux:  "a18d51d6913166891ae349596a0768c9ae09d66846bfb52785ab88488c1bd41b"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmdmake.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec"bin*"]
  end

  test do
    (testpath"hello.gop").write <<~GOP
      println("Hello World")
    GOP

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}gop env GOPVERSION").chomp
    system bin"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}gop run hello.gop 2>&1")

    (testpath"go.mod").write <<~GOMOD
      module hello
    GOMOD

    system "go", "get", "github.comgoplusgopbuiltin"
    system bin"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output(".hello 2>&1")
  end
end