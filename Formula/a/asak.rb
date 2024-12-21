class Asak < Formula
  desc "Cross-platform audio recordingplayback CLI tool with TUI"
  homepage "https:github.comchaosprintasak"
  license "MIT"
  revision 1
  head "https:github.comchaosprintasak.git", branch: "main"

  stable do
    url "https:github.comchaosprintasakarchiverefstagsv0.3.3.tar.gz"
    sha256 "e5c7da28f29e4e1e45aa57db4c4ab94278d59bd3bdb717ede7d04f04b1f7ed36"

    # patch to add man pages and shell completions support, upstream pr ref, https:github.comchaosprintasakpull18
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patchesf833fa6c7880376cb5ffe90f4d154368be04517easak0.3.3-clap-update.patch"
      sha256 "04e7172fd4ca7a643849077fcb6bd4baefadaa54231c06503e1946ec8ebcd811"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ed8ad6aff3db12016ca1f7f2f0242ff2373eebf52707125a67c326d0416a79b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bd72ff2e29d2a12e2e7a3970c55505329d0cee01d76418baba55b3ea3a6e0de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b2a5bfba37fd35fdafc19cc8f7cf44fc1d1d764dadf912ad7b0011154556670"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f555b3fcbaf3125eef3d2dc3ce942777c3982f526b1d5f96bb7d049c23033c3"
    sha256 cellar: :any_skip_relocation, ventura:       "1906d3fffa8236bdf4d41c625fb9273cb61bcb6a23987818294e86003a65d45f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b773ec9f9d8c4f69c29b99a2543d9b1be34029e475438b6236916d2fd8f885b3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "jack"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "targetcompletionsasak.bash" => "asak"
    fish_completion.install "targetcompletionsasak.fish" => "asak"
    zsh_completion.install "targetcompletions_asak" => "_asak"
    man1.install "targetmanasak.1"
  end

  test do
    output = shell_output("#{bin}asak play")
    assert_match "No wav files found in current directory", output

    assert_match version.to_s, shell_output("#{bin}asak --version")
  end
end