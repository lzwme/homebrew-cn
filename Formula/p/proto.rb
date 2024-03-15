class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.31.5.tar.gz"
  sha256 "f91035029b144538602e8577c25a043a8778ea0924fd9e2011c0e4697cee047a"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "90dff6d39ad8c4687aa204212b65876f513156cdf467ae70da8683e7ffca9f41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "961ae8cd6392401e76600bec5d8d129d95e8a5e65008a37d72e7630209eccf1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46e3bc4e5267908f70ccfbbd36c82298410bd1d1cacb001044a325750d5110c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "43a66c57dec8a4cc8c4303214d8343ca923c67fa763149c048b9198977716c95"
    sha256 cellar: :any_skip_relocation, ventura:        "016fa00226e2579328503abce29cae92ac1e76e39b2a0dadd25f6990c239e5df"
    sha256 cellar: :any_skip_relocation, monterey:       "b06d541f9f7b9f284bcda6ce0a80695cd7db41a429ddaf1487c5785de7f2bbe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca28bde14da736f536bc8c64ebae772fce3d7406e67638440745d7a3ba1ff35b"
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