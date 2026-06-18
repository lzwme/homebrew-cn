class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.75.0.tgz"
  sha256 "99608a6a0f926f5a14829b75787608f7a95ff45ae631f5b12301633536225e4e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "989d136419099f327d8c9b7f0fbaf4f38c0b1fad5d02ad291f0dc9591064c967"
    sha256 cellar: :any,                 arm64_sequoia: "f018c82e10725b8e032ac8725d44cf2a510403cdca166ffb60862ee2a9c1f411"
    sha256 cellar: :any,                 arm64_sonoma:  "f018c82e10725b8e032ac8725d44cf2a510403cdca166ffb60862ee2a9c1f411"
    sha256 cellar: :any,                 sonoma:        "1b23c23bde7d5648d61a87e0b1412d908e5e512ca8edbf540203cce1e150095f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a85f9c6cca6ef67304f1d29b9950ab05f298a431b0ff3976aef25c087ab96e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54858391a2abe1930c8f7366a02d97f6b13ec247a97b35dda2a589ddb5483349"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end