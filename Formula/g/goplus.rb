class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https:goplus.org"
  url "https:github.comgoplusgoparchiverefstagsv1.3.7.tar.gz"
  sha256 "427db0b9ce97c4d0b287b03eb1e5ba44dc88f5d146894636f1c61acea63d0260"
  license "Apache-2.0"
  head "https:github.comgoplusgop.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "4c6536adabb0dd794588882ff9d75b4e70668e74876662fb064d40406b1e7fac"
    sha256 arm64_sonoma:  "29ba2772bbc6b0b8330c906d98c8399640db3e06915a7cbfcfffeb3d27431171"
    sha256 arm64_ventura: "b89865e5435e0d489fe8786fb37d344ef5f04347d2fec1d51762e3f021163553"
    sha256 sonoma:        "08ae3b6b80dde008610c240d6e14d36734f644203ec33578873576a9be646841"
    sha256 ventura:       "fb390242d39ca1bf6a8e5bc951020d16618f4f857502960e52776d07be5444d0"
    sha256 x86_64_linux:  "6d60e4e5c1e3015ac6dd2e4ba64aabf08585d9b4d0ece4fa4d5c8ebf45c84428"
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