class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.3.7.tgz"
  sha256 "8399b5ad3b2afd26d32031e32d51b458cd74ab7515a8b38c4831f896c4d76c5e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e8fe5a068c4117c1d49f544983c58a7788359cfd697419d9327777cd1724dfda"
    sha256 cellar: :any,                 arm64_sonoma:  "e8fe5a068c4117c1d49f544983c58a7788359cfd697419d9327777cd1724dfda"
    sha256 cellar: :any,                 arm64_ventura: "e8fe5a068c4117c1d49f544983c58a7788359cfd697419d9327777cd1724dfda"
    sha256 cellar: :any,                 sonoma:        "ed7c4e0e1b55f3a23da9a9e02ef2dcbbe876537749b6d86384cc96a76149d928"
    sha256 cellar: :any,                 ventura:       "ed7c4e0e1b55f3a23da9a9e02ef2dcbbe876537749b6d86384cc96a76149d928"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6324241865e4f2833fcefc2ff887d309db5a0498eaeb004a7ad5e9cf1fef970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "101b965e3e6e3dffdc471e19b82155738138504e394986b80d0191cd81b72218"
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