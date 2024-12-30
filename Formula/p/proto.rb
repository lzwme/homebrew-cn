class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.44.2.tar.gz"
  sha256 "1de5f781f79d02ac4f17a56a9ee6783a15d0cda77b2b1bcd80bab9e5bac9285b"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0bd254403797dafa037ed0240c9e9a0146225e554eca8f36a6f661ed5b77a84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b5924ecb195c0bc11d6a0bbb0e9928e24c764f65167e406044f608b040b69b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eea4282575e9c9387d8d361d1cf4ade50d796f936babbcd9c335ca0879df8806"
    sha256 cellar: :any_skip_relocation, sonoma:        "828fa0a5d4d59812c603ff5ebc7c0d95e3a076eb33a16aece0b747f9e9896066"
    sha256 cellar: :any_skip_relocation, ventura:       "7818122b7988d62061b94880d9aa5889d719a0d9678f78f109a8b915387c5362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "636bfbbb0be72e03cdc44bc5a6adf656b7fc91be37a9f7dc737238d7831f173c"
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