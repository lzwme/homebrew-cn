class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.35.4.tar.gz"
  sha256 "fa85fb92fa5df67c91cf675873e685de11d88e0bbb263ecfba730df8db4efb79"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46bef854cbdb0ffc45ef34602c09931508211cb846554c4e2537aa29c75aded6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e1a8696fbb74a7af443635724d1e1e8be05d634d484dec8d4b6f30cbd04098"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5cf6d6ad8f29e4cfa89f1611d34fa732d8628abc9afb2dd444a6fd3ac5ec00e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d37d835179fe81f3c4817aa529dee359c2f8bfa56e7de67828b9c4b6017212dc"
    sha256 cellar: :any_skip_relocation, ventura:        "ad7c2b74ba5fbfe403d538cbc564b95448061796a3707044e49e3a2b0c3af768"
    sha256 cellar: :any_skip_relocation, monterey:       "8070bd884fe4d8398c39049f8982801e3a84836462826fa80a3f33cf3f636673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cdd34230c9dbbae286ae31f32e2c591db6f921c68b4abb3c3320ef9c0b292a7"
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