class Codex < Formula
  desc "OpenAI's coding agent that runs in your terminal"
  homepage "https://github.com/openai/codex"
  url "https://ghfast.top/https://github.com/openai/codex/archive/refs/tags/rust-v0.5.0.tar.gz"
  sha256 "5bf7caa5f3a137850390a99f471a1b497cd2311a6c592b85c2c86290bda743d8"
  license "Apache-2.0"
  head "https://github.com/openai/codex.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rust-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "597fd4308fc3dde249d83dd0d1e6d570bfa6a6faa040cef3be225581d07db706"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba99e0736dc273ed20a7be042acc004675f65c5dea920aa8378bbdd606bf9ae6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2812a6c751e076664c729f1eaf8c77a4a2377a14d72b09f06a78f67e1be2d962"
    sha256 cellar: :any_skip_relocation, sonoma:        "b77cb4d73e275f58abff625447e90cd41e6cc5ffd52d0f2733acea1462b27daf"
    sha256 cellar: :any_skip_relocation, ventura:       "e423d2d6dd4b4e3ea1cb030f648f9f78a33b5d3c4a2e3fbdb491d77a05bad392"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51deaa057f1043412521015861e6bf8b8b663f8a3addacd99e3fd996990c51b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b64d49742fcf18cb93971f65de906f3bcda2b15c8e97a377a20ea128c4d5e1c"
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