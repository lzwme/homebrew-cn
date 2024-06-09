class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.36.1.tar.gz"
  sha256 "1827a33e21673adb172910bc77cac8bdbadb4a5d4a19b4a86a87f35a0355918a"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df63c111f36f3e250ea0aa536c83884778d807621837c108f4c4fd3321da771d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0475a3348a268ed81a976163bedbbc804087fd97517eee6bf0f309b64d46fbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "349e5a25b0d17c00dfe97381f06a461f8f26673969ca24a96b9eee58d110caa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce5167085fd89893742fb8a267254a46aecdf7e4ae46b51593cbf0887c198773"
    sha256 cellar: :any_skip_relocation, ventura:        "604618992cfdee969cd519bd55d33930cdbd37b94721360eeef2f3ec81a27c22"
    sha256 cellar: :any_skip_relocation, monterey:       "03be6e51f0a8d0e16b137ba5bcf983c11df3dc3e53ef5d973e33bdd99e81d297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ef1ee5e5fce4ed590032d1a3960509705d9c5ec7d7a4ff9daade4198fa6142"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

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