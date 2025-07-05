class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.2.0.tar.gz"
  sha256 "aa59d6af465d1fe89a82ae684ae3d8d5e6c1f6fbc270cc389c5966c6e969d867"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de52c42521b1eb60600fbdf03acc0ad0d26fd1be3eefbc52025ea480499ce75f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f1148326eb88cd542defb40f3a67e516f68b43ba5c125e0051b8b2001286b71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf952e4aaa33a0e7a466f88142b2308b666183356817078009fa509287a1bfd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "900f5c341f0d92d0ab57f154feb36e9e74c194adbf7b8780fcc0ed5d185bcfbe"
    sha256 cellar: :any_skip_relocation, ventura:       "4294b7944faf2913410c33215d751f507ccd1f845ed2be06acaf6bb72915df1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ca98099f91a0c67dfc91b7d598078ca8daa926de395259f25dffb26e38a8b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd89a26bfadf9c88d5f7aac77ab4832cf0c2f78eb4bfed8990b509589fa1a2c2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    if OS.linux?
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
      ENV["OPENSSL_NO_VENDOR"] = "1"
    end

    system "cargo", "install", "--bin", "codex", *std_cargo_args(path: "codex-rs/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex --version")

    assert_equal "Reading prompt from stdin...\nNo prompt provided via stdin.\n",
pipe_output("#{bin}/codex exec 2>&1", "", 1)

    return unless OS.linux?

    assert_equal "hello\n", shell_output("#{bin}/codex debug landlock echo hello")
  end
end