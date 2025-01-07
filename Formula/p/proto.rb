class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.44.3.tar.gz"
  sha256 "18b2f88369183bec5760118dbe1e4f9af90ef575ed815e301bcd21123ba0144d"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "371f0df5e09a20066e985a2a9b6cf28b0618991a8dcaa4b48a360cdc99048d1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9813a484cd89fac1fecf0438bde8d595a11ceb61bd8a528c35596b38956a36e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68f805e78f777f2ebb0e913222b13464d6c60de8b6dfb1966fc4de7fda7d9b04"
    sha256 cellar: :any_skip_relocation, sonoma:        "7450986f48ee1357acc4b389909cd609a420164984c9a3a39e28a79c92d9f70b"
    sha256 cellar: :any_skip_relocation, ventura:       "2030760aaddeb26fbe8668592434e39b4fa35e0f8f519c390cf2dc68d07635c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12ebd91e70929a6280f66597d6c0d5757616f76eeb493ed5ca445e9ded95db21"
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