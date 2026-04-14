class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "9b0f1c67f00c3a54d8a2fcacc916d5268af921e3ab15ac3c75cf028a407a2040"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c254b809558b9dcc1718d50940dc225e99cf2a20c318b9ce09a6b4925ad10100"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a031b467d3b83811760c94f394a687722897d2244ab1c288aebbce048b1898f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29a8bc0101090e5d476a150dbb2526d958631b81329c3c732693001c6d87dd69"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c50a7cf60c5f5eb8714300a9a759f2e88d7dfc49ee33e332e45b2b1477cece2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2919a217cb55732c370c4ab26c5bcd2f255cc8f8973eab5df9ed07f230081226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "279f26908a0283a7ddca11038f067bb48b02e56d84d0b57f2a515a4ffc513bda"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/nono-cli")
  end

  test do
    ENV["NONO_NO_UPDATE_CHECK"] = "1"

    assert_match version.to_s, shell_output("#{bin}/nono --version")

    other_dir = testpath/"other"
    other_file = other_dir/"allowed.txt"
    other_dir.mkpath
    other_file.write("nono")

    output = shell_output("#{bin}/nono --silent why --json --path #{other_file} --op write --allow #{other_dir}")
    assert_match "\"status\": \"allowed\"", output
    assert_match "\"reason\": \"granted_path\"", output
  end
end