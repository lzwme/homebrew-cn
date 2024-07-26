class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.38.4.tar.gz"
  sha256 "eae4e43ff88422e93ea92e1892cb229b93c9f62969f35d887d024b50e1a997da"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30658dee6f96a0339ae0d16b1e6feef363068a48c5ebe45a99fece2a4c2406a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29df941eea3c8d595d8d22ed356247138a5b9076ed6ea1683e42f3c665699fbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "febbd0bbc6e7baf791435c07cef5f10654fc25a89e38d2358c84e125c57eb2a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6a5efa9f9f0360aef6b76bb5a2e791c9de69e1431635ee4043204e048f3e015"
    sha256 cellar: :any_skip_relocation, ventura:        "4dcd467ab80fea967b8a31acdc6d93e9a35ad3449a961d9dea3c19889182bc90"
    sha256 cellar: :any_skip_relocation, monterey:       "c87db1be65083e1e0a5d01911950a03291b0433552672b66f2149cda09f34320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a9bb82a710f25f3dff47b4e3310b201d9183115c7183180e1243610df7ffc55"
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