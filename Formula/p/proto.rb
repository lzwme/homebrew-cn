class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.41.3.tar.gz"
  sha256 "de322c6653fe91a96bd49cf1702024d6a2ab3efc822c35b6b6fee89ce1bb1037"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19ffbcc103a155766146eaa6269c0316ef7b273dbdaa89a147a5bc07563b22ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "905f21c09e3b2ff50816b2dbb03e13cf3d619665a92dc80327a021f367493135"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bca3316860ea48a94de5fe9ef80ba3676b04b9e36ead063185c6ca9d6ad571bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1a34c471f4c42d4905a5f9e8aa93a8503d9ce2c8df2a9293bf0802e58a9af62"
    sha256 cellar: :any_skip_relocation, ventura:       "87c31c260e0d20a86e3865bdca1da3a98e34e4825e8ee10202699e872918a2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fa6aa43457e6edd6efbd8580f4927b739aba5d6a6bcac86606c50988551c775"
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