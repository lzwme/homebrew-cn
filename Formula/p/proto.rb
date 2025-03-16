class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.47.5.tar.gz"
  sha256 "6dd05f53eee28ca65e9e9f8265ae267345e0e15aabace65568a24a1bb79618ba"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "034207868c8ba754b30877c6184fbdc2242f42c7b154dc4e19fefed063115801"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eff41a3915d863c9cb92309c6393117796f77d4cef98241c747d2a89c8f0dab2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75cf3f4f97dec1cf5ee108485054bfc015e673f650aac1b594301a9de8bf030b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca64889d23c33e365c3ab51a62ce797fa034b1f081df253ec15476e978376f93"
    sha256 cellar: :any_skip_relocation, ventura:       "1439d9112e4db391d9c4d5ddb83d7f1589e1c940e6dd0a8ec589d992651e50c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f89905fc140e32f7a8231bcbbed7d1da11b58ac90be585cae81fa79ec799fa3"
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