class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.43.0.tar.gz"
  sha256 "724fd531e7d9ca10df107c589a3e11043e7041d4231b2367f33965267faf1dd4"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e6b5856f75a0e39aaabb2af05c7e3d809e286c00f402b5568f9f9f60bf553b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7481d9fd6363b9bc0da66414d105825d9829068d227e001deb65d64bf6a7c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab57022ff4a968a37f53a10c1e17c0aeaff786a4a7d894ef92b35e42ad1b9838"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8d9bdd2c9886178d2dfba3bc14409643bacc0035d71e1687fca2af53955c1ec"
    sha256 cellar: :any_skip_relocation, ventura:       "bf9567f9eb22eca5ed73e77317f4c6e219db67c2a26adc52de5b77f903751564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb66e894f8b817c666cdef73222ea4a0f2a52d6e967e128cfd84f1ba93e3d2c8"
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