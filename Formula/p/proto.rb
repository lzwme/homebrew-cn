class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.44.1.tar.gz"
  sha256 "ba9821f58bc4326340258122905a7c7946db1dcf3056a51bb88fc64d812c5bba"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "551466d8e909b0a4a63ac6dd4cda13343ce503011e206bf4e1c59dd0ca758f9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa9dadde089c3f74566f98b6e6918afa93565c11e202f283044ad27f67811cc7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acafe391ec9918b6e08ca04bdfefc29363861897dc5dfbc045b5a85b3450348c"
    sha256 cellar: :any_skip_relocation, sonoma:        "402e8603d489068a86b21f2101f5e15794c420cc3ae30b798bde8889e6113a31"
    sha256 cellar: :any_skip_relocation, ventura:       "5f3a534c30f30c08be24feba4e3c7f2d667c55aa167c237fd7b65191da73e8d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "744d5b142c5a74351f335866e4d80b8642e127a56913072b8bdfaf4417fd07b6"
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