class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.47.0.tar.gz"
  sha256 "4afda80d587d5b3aad3377608851c84497a37eb0ce36d5686d5c11dd2d557a5d"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cadd28bb64780d56fc3ca9ccbede525648dae26995d40c0e44f5e31e5b2fe99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2acedbd59bcbf6b3cec211cad379230ad83b01d5fc23ae678e61546e0767990d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b9d9472e3d64146fe2c0e6e270b1745fc41cf5f0a82f3d3cf0f3134d8fced03"
    sha256 cellar: :any_skip_relocation, sonoma:        "22c9f156128b9490ea1a8df4a82e4ee30d3580f645435372e6a37d03a0834716"
    sha256 cellar: :any_skip_relocation, ventura:       "d60808d6f20837d50a7c5f6c67b7f9770147f5664c563c60331b435e80badc47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6a15f8fcc663bf7b6c3107b0fd008d0ddb032ab73a130e67113a927a149e0f7"
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