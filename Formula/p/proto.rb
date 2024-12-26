class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.44.0.tar.gz"
  sha256 "118c710b704b44e83b12a1193d035f93d1c0952c69d8c43db21aa833209fe3ab"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffc1f8674685193a30bbc46b315e6200cc4f3a02e6a36f4ef48bd398faf5b34b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "619b38c7018090b44ff6abe7af3b3a3e2ce9fe49087d72fe42bc6aacdadbf45f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5585788a00a569c436937c40b0aa3f5c707d8888aaed95263a5f710e19420917"
    sha256 cellar: :any_skip_relocation, sonoma:        "23b1173a1433662753548575784a8a1b0165cb67364f90e415e3addc535ce86c"
    sha256 cellar: :any_skip_relocation, ventura:       "3ff07b0cbdbf2432497efe832d189b4890d532307496ccdc4954bb791ee26a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe0cad752addba449dff46a0a26f2b9710e10bd3d02f99cbe966b70fa869a5da"
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