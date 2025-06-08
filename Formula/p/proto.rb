class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.49.5.tar.gz"
  sha256 "7286f4671ec263a8634c5aff01e4172a2fa2e8a9c57bade0942599d4bbcbe3fa"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "534874101be26b7df3307ae35d345bbb4f615a57cea1b4db81137d4b3bfb77c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ff124c027fe9876d811421f19e7ac5a5c9c5e728a6f76e7eb6a6bb17e8ebf49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d9673550c686e464e4e3b78ff6678e10bd9b430736b9ddbc2d721d0093fe0bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2d88d134e9819234dc906bfabdf975b973784cd6a639fd31b942e5735faa2e8"
    sha256 cellar: :any_skip_relocation, ventura:       "f7c5bf95dcf3613c39c5566e3d51d4c562d143d663f74292631eaea1b211cc90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05b76c37a213c9c3c020ee9c19edcf8eb2200e5c67ec408aca0d2246ab6344b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84ba822fa4ab809330719b1f5de00602e67ff1c8272a260af8be816984bb9155"
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