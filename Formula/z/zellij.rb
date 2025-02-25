class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https:zellij.dev"
  url "https:github.comzellij-orgzellijarchiverefstagsv0.41.2.tar.gz"
  sha256 "12e7f0f80c1e39deed5638c4662fc070855cee0250a7eb1d76cefbeef8c2f376"
  license "MIT"
  revision 1
  head "https:github.comzellij-orgzellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "655a14105b71be3b1700071975b75bfa48f975f37ce7926bece12b3a9e92028c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc009615009b732e182ce55a7fcefb7509cc380b21291e2559474cc3df77c07d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd94c8d0825ec15968d604d9c5f414294b45e475e2f2c5287edc9405b0d4a9cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "92066edbda62a75e2a33d4fb215a7d013b44750e30884714defcba388b9df8d2"
    sha256 cellar: :any_skip_relocation, ventura:       "34dcb5019bec333fd3b6e0b7b104def083e545f0ef1555ad8d408bcbcfe8e2dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fd72990ffbded09db184dfbce2e3fb5caf1cfc784cee5fa24978197a021f571"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}zellij --version"))
  end
end