class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.20.0.tar.gz"
  sha256 "6140b6d8372d9e858c4aded03e465694ec3e751dcf150e5e39372a383c1270c3"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24f86d3a92f69bbaea0a9dca49ca4beabecf4205caf80a20e196ce248b87a7b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08a023db15379b6e4b262e58baff7f345df0fe95ff40160ccbd709b3f674db80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "982aa8c8870cb9e974862756007957bd54705781479f17ab99e16a78e11fff4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "682498da317871c0e5dd2fc4b58166cc04824f8a38febff3d22d292378bab865"
    sha256 cellar: :any_skip_relocation, ventura:       "6dfbaff4cbc4d2d01c151b911508997fa9ab9e0a8c88bf8e54081cb17fe17517"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00c3016544fd7c34f2804ef1e8d690c826a4cf2892ee16d06f577e6af83ea994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34d0fc6dcd5507d7a12b3d95e6d8d80d4f8427863e9adf4e0fb7686c9533850"
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