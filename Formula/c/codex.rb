class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.16.0.tar.gz"
  sha256 "fde82d553a7741a12062ceb1ceb50725f90feb684c549252b29688f2cff2f719"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97237f18e76b7fe6c52befcb17726bb2285dd2989aa8bfa25a58d68a30ef2635"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0dd70134b7a9ab9e0f091be0900bedc2b5a370e7ed2bbb81cf81baf2d956992"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67841918aabbeca9799c262aa4157515df5381bc199ae486d554af28dc72f119"
    sha256 cellar: :any_skip_relocation, sonoma:        "823902a82e338d8c9bf352f085cad21a19489de6e6e07f44bfc972b294c0c25c"
    sha256 cellar: :any_skip_relocation, ventura:       "8d29a8e21ab5a530b32e46de78fd85d5574868dab21c357c214751cf7ce9e6ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bad65ab97dea62a1ef22b64c1dcd5b52c34a3211a422d839206bece0d6830214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9cd7a9ec63a858fdfe784856509634a038e5b0b69f7ba3d1da4726fefa455e6"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    if OS.linux?
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
      ENV["OPENSSL_NO_VENDOR"] = "1"
    end

    system "cargo", "install", "--bin", "codex", *std_cargo_args(path: "codex-rs/cli")
    generate_completions_from_executable(bin/"codex", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codex --version")

    assert_equal "Reading prompt from stdin...\nNo prompt provided via stdin.\n",
pipe_output("#{bin}/codex exec 2>&1", "", 1)

    return unless OS.linux?

    assert_equal "hello\n", shell_output("#{bin}/codex debug landlock echo hello")
  end
end