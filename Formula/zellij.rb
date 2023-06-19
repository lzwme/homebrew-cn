class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://ghproxy.com/https://github.com/zellij-org/zellij/archive/v0.37.0.tar.gz"
  sha256 "8f33360fc539bb755a8a63f9cfac0f5a3733af4e8c3c7dc23d67465797b3e681"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e0523937a76bc484bf476734158dcb1638f4d03cbecd19a1bafb1e809f1b206"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "999cafb5d3f9bb07554546d02b58481b3bdda7d62b0765c9b0885a86dc96516d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11f4acc0231634590b526a844eb0fe486d92613692f6a41388c415e3407d43e6"
    sha256 cellar: :any_skip_relocation, ventura:        "4b791976266c1c82b9672384258f07cd6f08a9592fc216d56a2dd3910899db74"
    sha256 cellar: :any_skip_relocation, monterey:       "c3c2bca6c324f119e21684f1b0b3055559d9b1ffcd910b9d4e9164f4f6d140c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e828868952da4910fe88d0b7e49da8726647b1258fe4e6e5c77864613b8d709"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43201d38ffdba2f149c1174baa5074edc5f403c912cc74197a66c1f27cc9d2a7"
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