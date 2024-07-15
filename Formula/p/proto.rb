class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.38.2.tar.gz"
  sha256 "84e690f169e31334f42e71f9572812050bea1a2b64318c70124cb094c62baac6"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c2e327d0fc202fb519ff639a8ace2732badc608ef2f2a3483e0dbdb3e44509f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c803caf915f19e7494eda6268bf3407dd43f0e620ac0488a933d4f804752bee3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3508a3a6341c318f7d2d74792357d7492e795239cfad3ed30c3a34299a6c0a19"
    sha256 cellar: :any_skip_relocation, sonoma:         "80de472ada702be39cdbe3ec0a08e0259a2b861c46b792716c4162d255a0a308"
    sha256 cellar: :any_skip_relocation, ventura:        "27f3d06e4899d65a51c983f38c8285c0894327f54a47c665c642f1d8709ef278"
    sha256 cellar: :any_skip_relocation, monterey:       "b9a54f9f82e740b0f92f719d4a1ce840e2383539a015e8dbe5f8d968a155dc96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90694597d7243e12ad55d0d857e708b26cfaa7aead95f23d122f4cca2e33be04"
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