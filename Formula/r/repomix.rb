class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.30.tgz"
  sha256 "997994a87fb5dc8dc09cc4091d6b7415a3cf65fe9bd749806942ea4c6d8cfb0d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3e253b77fbab005795076f7976aa52ce942c934a0a17a29bb991927a7613c77c"
    sha256 cellar: :any,                 arm64_sonoma:  "3e253b77fbab005795076f7976aa52ce942c934a0a17a29bb991927a7613c77c"
    sha256 cellar: :any,                 arm64_ventura: "3e253b77fbab005795076f7976aa52ce942c934a0a17a29bb991927a7613c77c"
    sha256 cellar: :any,                 sonoma:        "859e602dab4976fb4aadf4b41cbee478a1364d06af41cb41dddecbfae09e5137"
    sha256 cellar: :any,                 ventura:       "859e602dab4976fb4aadf4b41cbee478a1364d06af41cb41dddecbfae09e5137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ec8a9840e0e85ab5b752581e2d1c9f5299fbe24ce87e1e93fff3d7914b9751d"
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