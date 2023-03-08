class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://ghproxy.com/https://github.com/zellij-org/zellij/archive/v0.35.1.tar.gz"
  sha256 "fa92982ea3b1481a1c50065f9d1c3eff2e47ac0deee071ca4752a18424aeb93e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "839a768a5d4e60630d66ff005d474031a7cbb9da2d31117745e0d0d34cccfc30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7d51d5d6e60af0df7c9ab730368151096e93265b76ce81a81f8ddada5cb66b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f56c3251b463634b983839ed37e05b4b32f3db7968c3c41267786526f4cc59c7"
    sha256 cellar: :any_skip_relocation, ventura:        "10e82b724bbddfdc30e85f8e997829a866e7746afc2f2be5a66ccaa19eeb9889"
    sha256 cellar: :any_skip_relocation, monterey:       "d88bdca4a6cb87c10e4bd202eac57febc33b2d105c52806fc360c604d854e1c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fd82fa48a5a90b18507e945e032aa7dc700c90e6878961d68e946585109f4dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84fdee8e7bbc8a234bb5f59a1de398aca867bc2594925d38c6b87981d8810ec2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end