class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.23.tgz"
  sha256 "4ee1b7e067f528f42ed4383875c33a9ce9a341517cfc059436c9dd326d539f2b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "44a864010a79245e8d939bcb7d0f3499cf38c5e8dd7d22435c900bdfd24a9be9"
    sha256 cellar: :any,                 arm64_sonoma:  "44a864010a79245e8d939bcb7d0f3499cf38c5e8dd7d22435c900bdfd24a9be9"
    sha256 cellar: :any,                 arm64_ventura: "44a864010a79245e8d939bcb7d0f3499cf38c5e8dd7d22435c900bdfd24a9be9"
    sha256 cellar: :any,                 sonoma:        "90c3aa7806ad35012f69a5bf2b8041849196eab9f3d6be55ad69a97911a1e475"
    sha256 cellar: :any,                 ventura:       "90c3aa7806ad35012f69a5bf2b8041849196eab9f3d6be55ad69a97911a1e475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5147db60a94d1cf1df9e0f7c163430e71f331f5f732d3613da6dff2d57368c37"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    clipboardy_fallbacks_dir = libexec"libnode_modules#{name}node_modulesclipboardyfallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}repomix --version")

    (testpath"test_repo").mkdir
    (testpath"test_repotest_file.txt").write("Test content")

    output = shell_output("#{bin}repomix #{testpath}test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath"repomix-output.txt").read
  end
end