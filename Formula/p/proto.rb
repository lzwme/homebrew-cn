class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.47.11.tar.gz"
  sha256 "c2b5daccd588f0885a2a5d30f56884832229c46ba70ea1dd6c462ae80fbe8f78"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5662bce5e1f433bff959db6ac0640862191e2c15cfc83174d70e20cdd330487b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e8ab43349dda46c6bf608b022b6a4db81873e853c7580642bb6be4aadb68134"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "102c8562626a8200bdcd283727249d63acd5ac9aa1899f8276b3346f24d3c45f"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa79e2daf398e833b0a1d27f3d7ef48cd7a048662454173094e8562047de3c11"
    sha256 cellar: :any_skip_relocation, ventura:       "73292a61b6a63b9b551e9736bc292502a0d01061388bf5d076131588255c4ba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8d58b821a8489ec09829d62bbad56507b24521b6a43a8ea5e59d418195b31c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8ca2a7e185594c69f755e1d9c9262b2f42bf2fc900a10d84ab420ccf2ac9521"
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