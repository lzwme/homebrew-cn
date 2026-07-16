class ZshPatina < Formula
  desc "Blazingly fast Zsh syntax highlighter"
  homepage "https://github.com/michel-kraemer/zsh-patina"
  url "https://ghfast.top/https://github.com/michel-kraemer/zsh-patina/archive/refs/tags/1.8.0.tar.gz"
  sha256 "695420de546698b68078f9f7bc6d37bdbdef1eeea7907552d523d6f8c7a9ee06"
  license "MIT"
  head "https://github.com/michel-kraemer/zsh-patina.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd3be03d5a377279d57dc06dbe9a37810eb9d927be277127cf4ddcbb57652be0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3040a8bb2b849e808b97f32866170b0f31ee5a37fd57899e67b29574a8263cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "221b8a3b2a5d3b7e3e2f2307a990220e3afe83f9c86082c9d3ff4fc88234cc06"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c4d31cdcb2ebbd57ee350ddf4d44022af0663b4b55af52b9fd67be9e2715b7c"
    sha256 cellar: :any,                 arm64_linux:   "307d1b4e337c1aacec2327cd4350f2ea32ce171abe2e1e602d072fd198553591"
    sha256 cellar: :any,                 x86_64_linux:  "6734e5843cb6c662feef9aaead6206e47e8b9594de585ecfe43d75f1b2e8d3da"
  end

  depends_on "rust" => :build

  uses_from_macos "zsh" => :test

  def install
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "fat"
    ENV["CARGO_PROFILE_RELEASE_CODEGEN_UNITS"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"zsh-patina", "completion",
      shell_parameter_format: :none, shells: [:zsh])
  end

  def caveats
    <<~EOS
      Initialize zsh-patina at the end of your `.zshrc` file by executing:
        echo 'eval "$(#{opt_bin}/zsh-patina activate)"' >> ~/.zshrc
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zsh-patina --version")

    output = shell_output("zsh -c 'eval \"$(#{bin}/zsh-patina activate)\" && type -w zsh-patina'")
    assert_match "zsh-patina: function", output
  end
end