class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.41.1.tar.gz"
  sha256 "f3c5f2327a91cc764ae791b37e922cfb78b3d82ce4a4101c2ab73c66ec5f51ab"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7a48e485dd09e11a5e95e1427b752e3fae95263cc36a0dd17906d06931435780"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c27f7ce69baa6cf8ef681ecceb1e8f48b7a1ed4af3d676f38b1fd128d47dd331"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92cdf20a4a808d9fefbe43073d468e0e2d1cd196c228f0743a3d88fbd6647b27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "209f19d256ac0d7e4e52024ad9dcc64d5f377c96b6f77c145356f0e01134a0e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2736542677c8fc9a1741a5228a5d5eaa0a084109a3b961d62cf9332d840a7462"
    sha256 cellar: :any_skip_relocation, ventura:        "6bc2c8cd6b0e08c4c6403b38e257021f2459fb3a6678e14cde48ed5c0be7c212"
    sha256 cellar: :any_skip_relocation, monterey:       "6d54224419fd98eb6b985145cc6cefa2e45abe9bbbc67c386eb3d49f17516c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a93fc94933f981ab28ad6fd0dc85233b035c9c80664590c387838ca045425ed6"
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