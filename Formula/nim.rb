class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https://nim-lang.org/"
  url "https://nim-lang.org/download/nim-2.0.0.tar.xz"
  sha256 "bd6101d840036fb78e93a69df6cf3f9fd0c21cd754b695ff84a3b4add8ed0af7"
  license "MIT"
  head "https://github.com/nim-lang/Nim.git", branch: "devel"

  livecheck do
    url "https://nim-lang.org/install.html"
    regex(/href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "980c2256825cb7512d1e2dba7c42c89c6090d2971c62a827ff3d3b6493ce704d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab4e6803bd3d5751c257d8836d375fb44f63605ae1d28379c609df2b9369d82c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64511253a16d26d731bdfb073cf1f01de19e7baf211d5c8fa66e3d1172e1db97"
    sha256 cellar: :any_skip_relocation, ventura:        "0d449e9b431ef8884007f28aabb7fd27d15b6ad918ef360fd058183218cdd1ba"
    sha256 cellar: :any_skip_relocation, monterey:       "871af7316a5c434d67ad4503970d95e874ea583d2633a755971a7881307cbedb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b73ca9bc5adc7aaf90f4fecd957b1960569d974da9132369cc5f5e66b3ec7b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad2ae9f691b1509ce3b68adabea4c49e7b975175530966402bc47c843c331a21"
  end

  depends_on "help2man" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    if build.head?
      # this will clone https://github.com/nim-lang/csources_v1
      # at some hardcoded revision
      system "/bin/sh", "build_all.sh"
      # Build a new version of the compiler with readline bindings
      system "./koch", "boot", "-d:release", "-d:useLinenoise"
    else
      system "/bin/sh", "build.sh"
      system "bin/nim", "c", "-d:release", "koch"
      system "./koch", "boot", "-d:release", "-d:useLinenoise"
      system "./koch", "tools"
    end

    system "./koch", "geninstall"
    system "/bin/sh", "install.sh", prefix

    system "help2man", "bin/nim", "-o", "nim.1", "-N"
    man1.install "nim.1"

    target = prefix/"nim/bin"
    bin.install_symlink target/"nim"
    tools = %w[nimble nimgrep nimpretty nimsuggest]
    tools.each do |t|
      system "help2man", buildpath/"bin"/t, "-o", "#{t}.1", "-N"
      man1.install "#{t}.1"
      target.install buildpath/"bin"/t
      bin.install_symlink target/t
    end
  end

  test do
    (testpath/"hello.nim").write <<~EOS
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}/nim compile --verbosity:0 --run #{testpath}/hello.nim").chomp

    (testpath/"hello.nimble").write <<~EOS
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    EOS
    assert_equal "name: \"hello\"\n", shell_output("#{bin}/nimble dump").lines.first
  end
end