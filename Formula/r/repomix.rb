class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.39.tgz"
  sha256 "415d596da82152524bcc6bbe1137f6436b25f98faf83c5e1ebdf315f3f90baf6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f10f926d4034778708c10d570622f53cd8312e96311199fd144ddf317575c5bd"
    sha256 cellar: :any,                 arm64_sonoma:  "f10f926d4034778708c10d570622f53cd8312e96311199fd144ddf317575c5bd"
    sha256 cellar: :any,                 arm64_ventura: "f10f926d4034778708c10d570622f53cd8312e96311199fd144ddf317575c5bd"
    sha256 cellar: :any,                 sonoma:        "e2ce076b5202a3a5e129e7a5ab51d390adfffa928aa0efdb2fec8bb8bf478ceb"
    sha256 cellar: :any,                 ventura:       "e2ce076b5202a3a5e129e7a5ab51d390adfffa928aa0efdb2fec8bb8bf478ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74c8a7ce00053545ce19d4a61e50f8d8dfdc7c83667aa112f02100d7b741a9fc"
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