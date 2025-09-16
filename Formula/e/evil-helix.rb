class EvilHelix < Formula
  desc "Soft fork of the helix editor"
  homepage "https://github.com/usagi-flow/evil-helix"
  url "https://ghfast.top/https://github.com/usagi-flow/evil-helix/archive/refs/tags/release-20250823.tar.gz"
  sha256 "a06ca03fb7726cd22728593c641fcae5c4bc3c05a1dfb809352e471c4679a0c3"
  license "MPL-2.0"
  head "https://github.com/usagi-flow/evil-helix.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "bd9e375d5af199078bc4c72711db7a521f2b5b3a97ef52fca95c2a5c20020464"
    sha256 cellar: :any,                 arm64_sequoia: "e791d92c0c841e7ae072ba4d968fe134e027e57085d684ff1b16423f43c2d956"
    sha256 cellar: :any,                 arm64_sonoma:  "ef3d09e17e23e71775b36e905045665d5019bc5f43734306bdcbe690e6e59c5b"
    sha256 cellar: :any,                 sonoma:        "d65baae18537d61a3dfa818eab13ed9fda5afd9dc707a77bab3c2a9f07dda5db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "669efd02cadae489188de4da6d28656fd136e196ab412cc9e61ce33f1584b34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83c58153ceaea968ab8f90bc7c651193bafcc73f8df93e12eb3d5b594a10cc2b"
  end

  depends_on "rust" => :build

  conflicts_with "helix", because: "both install `hx` binaries"
  conflicts_with "hex", because: "both install `hx` binaries"

  def install
    ENV["HELIX_DEFAULT_RUNTIME"] = libexec/"runtime"
    system "cargo", "install", "-vv", *std_cargo_args(path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    file = "https://ghfast.top/https://raw.githubusercontent.com/usagi-flow/evil-helix/refs/tags/release-#{version}/Cargo.toml"
    version = shell_output("curl #{file}")&.gsub!(/.0$/i, "")
    assert_match version.to_s, shell_output("#{bin}/hx --version")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end