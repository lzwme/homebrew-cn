class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.30.1.tar.gz"
  sha256 "7ab4984b7b629f1a68b7515a4527ed96b2bc0533b2a307ba76b7412c6706c9fb"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9738bc65bc687d40d16e44c61758432094307177181becc1cd0287d00483ce0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2264553b23fde8d6819466dc86411cd0a2aac2bab5a53860f26993c2480e7f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64abf686db129794d89045a49a1eba54dc1a790f2788aba646c1ef65b960e3d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "dac24aa13afce23d2fa98418ba031edfd9ca3fbd213d95db7061bf2e4eedf402"
    sha256 cellar: :any_skip_relocation, ventura:        "c0be23d77c325c6eaabb282828f2a21f74d8ef7f800cca076539e96983e636ab"
    sha256 cellar: :any_skip_relocation, monterey:       "3bd78048aa9b4d84823cd9eada973092ebdac14fc95e7fd37cd7b282c2a6fbea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d258a791b917b8b174466d9ec3dfa92ecf1bd21b1d03a1bfcc4fe1bc4293eacb"
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

      next if basename.to_s == "proto-shim"

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, PROTO_INSTALL_DIR: opt_prefix"bin"
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