class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.35.5.tar.gz"
  sha256 "62815a74bd7f130791625bb5d94431fd654cbbfdae655cecf8b5a116ca6f3d47"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91f6ce21e91a612273e2812055bb6d304995ae196b1689aa5f30f6cb9c37d52a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37dc9ac1e8af6d01301864726369f390315137a41818bf863207de5641604483"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c583ae93f96f2e602853f0b74090bb7f6569190e094834657c6fdfc7c31afbcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b2267a32a2af6c3cf5bf26a0f0f9c74d88130ad907422ed8ef90cdeba86034e"
    sha256 cellar: :any_skip_relocation, ventura:        "23d9bcaba0252662b7e427c287b8b572b589a3f8edb5a5d274d80d3baf3227d1"
    sha256 cellar: :any_skip_relocation, monterey:       "5c189778f73461de52dde6ca3cedea0bb95c509ac1a902494d8837cf7b914639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e09e7af7aa00ff43a64ec3a6b76577f572987d2ef19b8d398018e277c89ef6f"
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