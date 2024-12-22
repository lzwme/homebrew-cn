class Asak < Formula
  desc "Cross-platform audio recordingplayback CLI tool with TUI"
  homepage "https:github.comchaosprintasak"
  url "https:github.comchaosprintasakarchiverefstagsv0.3.4.tar.gz"
  sha256 "171916d7964e2a54ae92b38ffdb67f841e21da89e1b1ffcfb96e385999e066f2"
  license "MIT"
  head "https:github.comchaosprintasak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d34a5b7cee6dcd07bb4d38e93b676203c68fdae4d1cc5e5b5b6426a1acc2d4ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53e25ce893336480ddf387172c204c5e0cbdbf6667192b848de067f8b3884eeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b77b36ae1bcd6c4297fe40350db70f69228cdbc5c86f2fd8099d942ffd9f6951"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8e422a1c9c71946ad6457ab745d0880ef685d2de977e30bf2c7a8ceb6acc880"
    sha256 cellar: :any_skip_relocation, ventura:       "31af89a6fd325f425aae104043edb6bf34d04b20a2b60a8ab8445f4cf777100f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7121900080e4d2c358a3a3f60ade6c11190d3e17e7d5423780f1d91d8384f277"
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