class BacklogMd < Formula
  desc "Markdown‑native Task Manager & Kanban visualizer for any Git repository"
  homepage "https://github.com/MrLesk/Backlog.md"
  url "https://registry.npmjs.org/backlog.md/-/backlog.md-1.9.2.tgz"
  sha256 "a104524fffe8d391daa01d6176539b3d47321e9b085f3f587d4edbac3c96941c"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "082bc1c4352cae3e5b007a546064e31c644ef9207762f4fdc6d1a6830a38ab05"
    sha256                               arm64_sonoma:  "082bc1c4352cae3e5b007a546064e31c644ef9207762f4fdc6d1a6830a38ab05"
    sha256                               arm64_ventura: "082bc1c4352cae3e5b007a546064e31c644ef9207762f4fdc6d1a6830a38ab05"
    sha256 cellar: :any_skip_relocation, sonoma:        "9924bfabd5c58c508c803052acddb364bca36c754352184d525b14e9ac93756d"
    sha256 cellar: :any_skip_relocation, ventura:       "9924bfabd5c58c508c803052acddb364bca36c754352184d525b14e9ac93756d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8326743993f83b5b0964c264451c9039735921ba2e590e88931d6d7b27b156ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93f7f8ef21c13f81a2e5f503f47c09ac0fb743840c26818911aab231222b1ae6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/backlog --version")

    system "git", "init"
    system bin/"backlog", "init", "--defaults", "foobar"
    assert_path_exists testpath/"backlog"
  end
end