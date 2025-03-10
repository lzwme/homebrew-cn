class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.36.tgz"
  sha256 "0ea74cb49bf346b4f7b9a39efe20ee36e5d8f04b17b90e0966b8457901b2b069"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5168c9b495508c5417e8614400c369fd6bd6a8469d5943dbf7d8bf3656ddb684"
    sha256 cellar: :any,                 arm64_sonoma:  "5168c9b495508c5417e8614400c369fd6bd6a8469d5943dbf7d8bf3656ddb684"
    sha256 cellar: :any,                 arm64_ventura: "5168c9b495508c5417e8614400c369fd6bd6a8469d5943dbf7d8bf3656ddb684"
    sha256 cellar: :any,                 sonoma:        "62521dcbd130e2f5d7d844908bdb3e71c486bd08ab3893391e82702422735639"
    sha256 cellar: :any,                 ventura:       "62521dcbd130e2f5d7d844908bdb3e71c486bd08ab3893391e82702422735639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb25b136843175eb42dba894e299412674cf845c601dd912716ad2d918a314c2"
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