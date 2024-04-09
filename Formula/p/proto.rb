class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.34.1.tar.gz"
  sha256 "ed57b39c556fcbc024706790c29e692ef737063de0621c02cd5cb3724374ea36"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e7207727eb202c8521c68468fd38ab62e88b30113ca210fbd4d763dfe73af60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fab23c5dd0da92ad742f095b8ec0832b3ad9e74686257bedb1005e7dab3e89ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac267ca045a0020621e73d679feabd45c037eaf60e89219e1c9a31db11ccbf7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "8be6d3b52cb048b9ce9bd3a75becf00aed679cfa7630c9ffb58cfecbc1b05619"
    sha256 cellar: :any_skip_relocation, ventura:        "efde562434b68e8c9a062b5bc7219c7d1e84863c0b8f89464efda35e46f3eff9"
    sha256 cellar: :any_skip_relocation, monterey:       "abec28727cae9ae53188a7ce21c6573027e686c4b70d8a9cf8ab991aa5f94b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a6218e85e53309f444ad613f7e120226cd8104ad84ced52bcbc863c49ac43ec"
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