class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://ghfast.top/https://github.com/zellij-org/zellij/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "fd1cb54df0453f7f1340bb293a2682bbeacbd307156aab919acdf715e36b6ee1"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e00b587af7b76892ae8dc49bce7f3f3b9d8bd2de1b58adb89c61805073ba8058"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1082a1ea3711a15c534cd0f234c930c537c972d79be0743eb639e841c466f5b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20bc1fcc258c6014dcf1dba9c7d005983150b8b057dcd0a3418f8bbce555d0c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5432f003729e85fb26bfb50526d2cb26d92300b3b883bd44e2f7d9997966ebf1"
    sha256 cellar: :any_skip_relocation, ventura:       "1a8e38553b490d3e0ebe215b2e03e16365384de4f42e6c0c310cfed25d40b775"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbf62c3b1ecece66808938f64cde51f027eab93b6e044ec16888a016a2af1fec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71f36e8caff2b1233a4ed3900d0a4dec6a0b7a9288c9416a3188668e1a4bcbfe"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end