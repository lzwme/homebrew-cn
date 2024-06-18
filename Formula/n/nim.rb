class Nim < Formula
  desc "Statically typed compiled systems programming language"
  homepage "https:nim-lang.org"
  url "https:nim-lang.orgdownloadnim-2.0.6.tar.xz"
  sha256 "fbcd5d731743adec2b3bb9bcf6f5fd993ed11b250f957166bebf328f307cba6a"
  license "MIT"
  head "https:github.comnim-langNim.git", branch: "devel"

  livecheck do
    url "https:nim-lang.orginstall.html"
    regex(href=.*?nim[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02331d6a806f478fe9f03c35b5367c4d81f5b740b012c0bed4a36e4676dc922f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bd003300466eac499eeb2fa344951406b8170520bf831c2605316bfbfbc2415"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "247467381bbea35e3a6c6329916a094ad942ce3b9ffaa1e8582b7f3a0fd318a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4832c3264413d4c7ab2b85a4259abbf216cd5e5c450c5a5d44e4e4e75903e4e4"
    sha256 cellar: :any_skip_relocation, ventura:        "27726bda18b98886cf32cc3e902046ec0f84fa04a94f919be7e4454d29def87e"
    sha256 cellar: :any_skip_relocation, monterey:       "61bf916d2b54cbbcbd4125a9b095f4de5bda22bc46546d12e0ff73a717105b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c253943a6d73ded8f9976f6376a1a7bb6c7c7db900bfa159df78b77f98369736"
  end

  depends_on "help2man" => :build

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "mongodb-atlas-cli", because: "both install `atlas` executable"

  def install
    if build.head?
      # this will clone https:github.comnim-langcsources_v1
      # at some hardcoded revision
      system "binsh", "build_all.sh"
      # Build a new version of the compiler with readline bindings
      system ".koch", "boot", "-d:release", "-d:useLinenoise"
    else
      system "binsh", "build.sh"
      system "binnim", "c", "-d:release", "koch"
      system ".koch", "boot", "-d:release", "-d:useLinenoise"
      system ".koch", "tools"
    end

    system ".koch", "geninstall"
    system "binsh", "install.sh", prefix

    system "help2man", "binnim", "-o", "nim.1", "-N"
    man1.install "nim.1"

    target = prefix"nimbin"
    bin.install_symlink target"nim"
    tools = %w[nimble nimgrep nimpretty nimsuggest atlas testament]
    tools.each do |t|
      if t == "testament"
        system "help2man", buildpath"bin"t, "-o", "#{t}.1", "-N", "--no-discard-stderr"
      else
        system "help2man", buildpath"bin"t, "-o", "#{t}.1", "-N"
      end

      man1.install "#{t}.1"
      target.install buildpath"bin"t
      bin.install_symlink targett
    end
  end

  test do
    (testpath"hello.nim").write <<~EOS
      echo("hello")
    EOS
    assert_equal "hello", shell_output("#{bin}nim compile --verbosity:0 --run #{testpath}hello.nim").chomp

    (testpath"hello.nimble").write <<~EOS
      version = "0.1.0"
      author = "Author Name"
      description = "A test nimble package"
      license = "MIT"
      requires "nim >= 0.15.0"
    EOS
    assert_equal "name: \"hello\"\n", shell_output("#{bin}nimble dump").lines.first
  end
end