class Nono < Formula
  desc "Capability-based sandbox shell for AI agents with OS-enforced isolation"
  homepage "https://github.com/always-further/nono"
  url "https://ghfast.top/https://github.com/always-further/nono/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "dbc229b13ebe1e86328987166ea86316c8f94569b822c555330f774ca1405c34"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22f0aa80b7ab753d0e5ad1e06d6889340d564f9af35d4e1f7c9abc96278b9b67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ad780254c74faa040ab5a86c94a91536f3b82226b877f92f91ec88a617c4b6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99c80fed18a8382e43220f762c3f4ab515a51b3de2a6df3c544f1ba18ecbfdfd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2fdd13067b9edd33efb1498e2af46ec1c4028885c202f93b07134de9f97c81f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e0426d1995cabf27dfad992baddbce362e50fe1dd2960f165bef911776f4caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6630232e39438f306ac9c60841998f35b920219db49d777518d96068cc192c80"
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