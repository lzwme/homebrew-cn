class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://ghfast.top/https://github.com/cachix/secretspec/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "2701b24fc2aaea6e888500df5c9f1cb2ec0d1b84aa3773ee8046754b9c86787a"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a37ff711f4f1220b8c009090920f0d1464855709b8c6aab7dcbea5bce06b9a03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1010d91534ec6233d470a1506a49a92c94685bf40913f13a22dfba08f2dd90a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4d047a321b5486f3608dbea80b53cdce0bcab34880dfeb6c11a2219fe6ded9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b90e53fcbceb176994fda8e8fc8bf259126140e8820fe0d8ffa0395333e052b"
    sha256 cellar: :any,                 arm64_linux:   "7981c4b382c6bf961569185691e6a2409e040d26c95b7e283817607d58ff611e"
    sha256 cellar: :any,                 x86_64_linux:  "d266ad6a5f1f9fdb535f8b16d8b559f6042c7e61983e20f475e7aaa8935a3fb8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end