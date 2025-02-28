class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.47.2.tar.gz"
  sha256 "e1441ab1e2d17ad703ddabc2ad953b1b51f4835e491356846b7b380856b153d3"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9749fca7c4e4c886978a3d69b2f858f2e94cfedc58ac30ec5e52914c58e9eb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0c4445ae2c47cc897803c6e7220971c5a9e8dd8ab1ba5cfefb30caa7d565cae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a18cf40e399ad9a16801e7bec1f70f8495972773e4d435668b34cc2b59921478"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7576e497453956dff53da7ad2faededdb76fbb37ed9f10ac21e08ce34388fcb"
    sha256 cellar: :any_skip_relocation, ventura:       "deab3d1b5e69edb0159ea2b928f36e98fcec16a1d9abd55296ff74a3f459893e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8c596ee2e384546de8952011bab71481a2a26cfa850eaca38c0c26e0f3d7a2f"
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