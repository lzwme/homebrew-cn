class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.31.1.tar.gz"
  sha256 "d309be4bb5fb50543d1399103cef602311c6c69266979739fb17b6977470ef91"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb4277f897213a55d281ffe7e5890f311c8cc550f3d236d578caa7eb2dd03483"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "839c4aada20ae1d11add6eefdc434a8b155b385c98caa879dbd6ff01e3c479b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6abc67a7d7a3f7fafa894c026e14d390414d504f09db401b40d7aad6c94f170"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f4f6f7071067dd5bd9b58234f25818c596121e880e2bf8558c0ed76ac0d3f8a"
    sha256 cellar: :any_skip_relocation, ventura:        "d2041e3c63f22f939b6cc740593661a9957661922016f728f9f78856f3aa4249"
    sha256 cellar: :any_skip_relocation, monterey:       "71533529a1438da3159c23c359c5a99afd2c8694c08f5232e5ce2c458af27c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbb460fe40cdd7af551d16cbd931b236f5c76bac5881aefa3abf5b9abcfbf4cf"
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