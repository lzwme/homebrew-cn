class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.35.2.tar.gz"
  sha256 "cec1fc0e6ad527d89b0005f868b052e2e62f4f890eeed81486354d996ee2cc16"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ee380caa81f5e1038e40f89d51ae9871175b818fb99e3633e3539922006dfdf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f492f530872ba65643de0173d616fcfd46ba7812fabbb62ac4281d85bf187fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e704bb5fd03d8763b04a762979f1655777ffc710dc30b101abf801d79cb6ebd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "a232c66421fec6ff29499a5b6f06dec5215713945f918c83527c1799264c5e94"
    sha256 cellar: :any_skip_relocation, ventura:        "5ee405d36c22eae4a32d18c65665c75a7634b65cee517724664fe5595145f2ed"
    sha256 cellar: :any_skip_relocation, monterey:       "eca4d6e59c9572c7712bc034f82551166d3d8984dd7cd9dcb5af5210a575bf8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cdc1dd8dd82b9a737193d35f2d8ff63e2c806776b37333414bddb5519d8ea39"
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