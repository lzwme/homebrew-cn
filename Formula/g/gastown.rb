class Gastown < Formula
  desc "Multi-agent workspace manager"
  homepage "https://github.com/steveyegge/gastown"
  url "https://ghfast.top/https://github.com/steveyegge/gastown/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "8254500f1a86e4f4b37d2229e6a3168b219df2093b89822216a67971318b70c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2caea6f4cd64a4694c5cfc5e7363d5c3d90601de53dd89eaaa1b2a52d20dc9b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2caea6f4cd64a4694c5cfc5e7363d5c3d90601de53dd89eaaa1b2a52d20dc9b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2caea6f4cd64a4694c5cfc5e7363d5c3d90601de53dd89eaaa1b2a52d20dc9b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e4cbc526aeef738a6ca9c40b4b678d7fb81d2952c757588c0380c499ef4c984"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da94e28ae0c569478d8df6531762ad4060d4062bbc494f74802e17b9e00f0e1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edab4678d1cfd175c27c732f0eb302017e5bd03d39c1d33ceb8f714a99bf50be"
  end

  depends_on "go" => :build
  depends_on "beads"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gt"
    bin.install_symlink "gastown" => "gt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gt version")

    system bin/"gt", "install"
    assert_path_exists testpath/"mayor"
  end
end