class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.14.tgz"
  sha256 "dcc90552101c911a4aa5b93924d36e874391c3d96c0dd8fc049791d510f616ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e7f17a2c578a510acc82915afd60c65ffb07c3e4bf2626fbc4033d49c1b0c08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e7f17a2c578a510acc82915afd60c65ffb07c3e4bf2626fbc4033d49c1b0c08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e7f17a2c578a510acc82915afd60c65ffb07c3e4bf2626fbc4033d49c1b0c08"
    sha256 cellar: :any_skip_relocation, sonoma:        "62d1f3ac35be48639c966fb6c987d2b250e2ac5321b8307ad8aea70a48cf77b5"
    sha256 cellar: :any_skip_relocation, ventura:       "62d1f3ac35be48639c966fb6c987d2b250e2ac5321b8307ad8aea70a48cf77b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0f5c9fcbe73abcf6494233271da7fe840e80c688dd3f04508dde461ee44b148"
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