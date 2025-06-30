class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-1.0.0.tgz"
  sha256 "07f6e6b38208d1174ae52f2e070032676c937ccf73871c356676a56a37830103"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cfc548e37390580f320c27ffe8be09063c348f2bc6cc97a438796a42d072eabb"
    sha256 cellar: :any,                 arm64_sonoma:  "cfc548e37390580f320c27ffe8be09063c348f2bc6cc97a438796a42d072eabb"
    sha256 cellar: :any,                 arm64_ventura: "cfc548e37390580f320c27ffe8be09063c348f2bc6cc97a438796a42d072eabb"
    sha256 cellar: :any,                 sonoma:        "4827d4296b401ad0d184dabcc8dec766463aaa150b3defb833a199006afdb0ba"
    sha256 cellar: :any,                 ventura:       "4827d4296b401ad0d184dabcc8dec766463aaa150b3defb833a199006afdb0ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e32fb329b52ecd363cfed6428a72c0ae7271108c8a9d0c2d7445ddc27b1a2dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a65140bbb658dd49fefdb7a25eeee66fb0b09810b22a4a6cc548e44f0637f20"
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

    output = shell_output("#{bin}repomix --style plain --compress #{testpath}test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath"repomix-output.txt").read
  end
end