class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.32.2.tar.gz"
  sha256 "81582f84a25c3aaf09718b5570e449b39c1e894d447281f6014cb084efe9d28c"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c7728b96fde82c7998feda104bc72ef93bfe9b8c4f4fc2f992e60fb3d7a899a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb7b7641cf4589f548015d6a7100128b8754b24ec44b159342588578d6c183b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "578cfee94d34bc5a12cb3caf112f82f689e6ed7a145d4400808bb1737f8a25b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2cafaadf2eb43d380fe18c2db89fc76fca1afe75a74f2d3d4774d13097608b1"
    sha256 cellar: :any_skip_relocation, ventura:        "658d642b101bdef4c8301267461ba0b8eae6b5cbbe954c2520ef8a3d0a330d1a"
    sha256 cellar: :any_skip_relocation, monterey:       "ead5628ebe22b918d4c830b873cf2068588eb617079a01b93d1ffaeb63d39514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e5e948e3689d064e91b56834516e3498b913b7a4609a95a9d837be5db0303f6"
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