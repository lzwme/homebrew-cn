class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.31.2.tar.gz"
  sha256 "063fbdb4a6cd0aada47d1b81fec720145bd9b418b350fb487960087312557f47"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bed489610b9024591063601c95171416fddea2b472ac0f6fc3627e25e30dec41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5135f49bbacc209fc16cf9fe42b61be0dc99e95631f0216a48083a72b25a1fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd120d5cbaa7a8cc475a12f85f17a542bccc1f60e4441590ac1329a796ba5769"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddc7501c7199c3c33f75b1d2cc43fb381481f4897e5df04b97f4c0356c7e5ac7"
    sha256 cellar: :any_skip_relocation, ventura:        "2abd80cc15cb39f0008c8624bf457c63f37ce699806b3294bf7fc2cef49e1bcc"
    sha256 cellar: :any_skip_relocation, monterey:       "b7d66bd1584fabe5df9e0ed1d8a97f6e1afe090f662ed4b6abd5aef85607ac51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4384329fd3e206dbed9b4c42a2c9e9dd2e476b2886f10d258350beef763fb885"
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

      next if basename.to_s == "proto-shim"

      (libexec"bin").install f
      (binbasename).write_env_script libexec"bin"basename, PROTO_INSTALL_DIR: opt_prefix"bin"
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