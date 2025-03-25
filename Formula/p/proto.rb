class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.47.8.tar.gz"
  sha256 "13c463a962640ed1bded18815f0289099a04e44a357c65ff45762457cd551cf8"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66dabd4835c632b6b227539665e06f25c677a3dce7c7f96aa5235cbc42aec5d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c57099410f734d5ef066400af464db7b8244666c622ff3479d98c9d93981a56e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ac144d341da4d16bb8733be32d321eaa719e8d179a6fec1f6a663666cf3987fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "143fa53205739fbb268b5c8e4bcce4a8d2ec022f18ba0214b625c1cfc642dcb9"
    sha256 cellar: :any_skip_relocation, ventura:       "58bc079aa497d30f6b9be1caa7584828c2c8508b5af445e594283c2816b271d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77fcbccebb80fd43db664f8265cc2b305a65998b2acd29b95cd797633eaf0181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba853540345ee88800d38edead1bbaee395b115881e2fd0470c36a87ac772cbf"
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