class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.41.2.tar.gz"
  sha256 "342fc577600cc8ebc8c3fc2f36a9b0954cdcce8ad411780acd67311d4a24f711"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "958e66de2b7d47983068ae952f9722fedef6b1d6fc3bbc27fe4929beb0e1c622"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a95b20a715f38212f48a177e761fc4359882685bfe2315485645744aa9cedf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "758ddc5acd616d8ce95a56c3d7d96b9d42be7cd3ba130f16d8fd9f736a03fdb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e30ab5029a6f961935c5134e8856ae02d8f32a20fa347d97fd1e256b529ea39"
    sha256 cellar: :any_skip_relocation, ventura:       "1fcb60e3c41be6cac9c0c3f3a34c34c4478fcb842113a4b94b0677ce73181937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b22a6157616d50cdd0980e5f998a38477b85530eb892f480ca22aaefa2a2f07c"
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