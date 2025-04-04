class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.47.9.tar.gz"
  sha256 "71b3ce0257181a3060ada089ebbc518aba54184f9732d51d2deee8c110079aa0"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2a7fdd52faea402e96a4a66721158b88615ef9a1922f797c0cc75a775d02605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f7795966e16df6fe033b3fdf4d92b4d8ee394def5e2c100dbec277d209db61d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8610fda088f9bcc4297c527d9d6faecad2804809150171a64800023ad4b767a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ef9fb4d944775965a719653742a5cd605c30697a396b04d8ec1f4f85437e87f"
    sha256 cellar: :any_skip_relocation, ventura:       "faa8acc135c88c1d2d416382703b6e848c86801ae6ca608808004986e1d51964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7288d1cfe28da9eaa1dd4d1efde36b94015a9502d8e4759eb36957725190922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f7ab1d4bcd502e6f5875417ed36cac68c884fdcbd559617e1d711f5518d865b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (binbasename).write_env_script libexec"bin"basename, PROTO_LOOKUP_DIR: opt_prefix"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}.protoshimsnode #{path}").strip
    assert_equal "hello", output
  end
end