class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.43.3.tar.gz"
  sha256 "69cb015e8b3ce88945eb4cf381f078ec247ea4add6c1d740cfad14d1a53597a5"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f292548bc7fc0d1a82b4f26bbb6e1581f3ef57ed7d442bb2ec4986cad85ef42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ffbee68e1ae01732c7326324ea52fad953ced1aee5b5af794b9dd0f0e03c360"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab8e94ea87c164a0955ae947d3567449267f6caf90611369546fd304ca9dc6dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ef1104abc7b4fba6faba6d042ddae80446b7b6f6d9b5b4fc27c693900d0f3b6"
    sha256 cellar: :any_skip_relocation, ventura:       "dc81c13eac3b4654b981e1fa7044d59e60488fab88e2cb42db6b45b6dd4cc3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1d3a626ba92c74442db50a95a4c7bfa1b0fed5130c84aa37928e1e978490143"
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