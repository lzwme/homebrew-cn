class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.47.3.tar.gz"
  sha256 "449b6cff2b7affe1e0b4f9540da0103de743d8512135fec413b385a9eccaaaf6"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e623b8a0ea1ed680617da8aa78bfff35e30414a53ea089ae7966e0e2fce8163b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf9a93a77c0d021a4c3ba43cefd5ed0e9d10fe9e483b787ef36185cdc5bd3573"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89ea8815944eeb86e25cf205a5adbb6736f79c3b7ecf6119b26be60d02e8868f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f5340b308a6a3c324e90211b606664f93c3cf55cfd61acec8ed189fb13f3b8a"
    sha256 cellar: :any_skip_relocation, ventura:       "50609217a8c8628ee33c986de76a3e7367a96d7c82c0377c00ddccf71e24cb7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fea9e5f5f9d09e8237206b9617cd3b557c01efde8a282b55d0b5e166e9fbc09b"
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