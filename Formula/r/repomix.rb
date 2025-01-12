class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.20.tgz"
  sha256 "b5a2e5454c7de25470d1cdf3ce54da1ecc23a9abe823d3ceacba7f205ce1c585"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "002f2dd076541382d831c79b134cd59e27e063d49b8b07375e59ffdaf50ad8a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "002f2dd076541382d831c79b134cd59e27e063d49b8b07375e59ffdaf50ad8a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "002f2dd076541382d831c79b134cd59e27e063d49b8b07375e59ffdaf50ad8a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1dd7048416b69c85e3a8ec703f863e20265091fd2e0daf9ea2cf6b9c8318352"
    sha256 cellar: :any_skip_relocation, ventura:       "f1dd7048416b69c85e3a8ec703f863e20265091fd2e0daf9ea2cf6b9c8318352"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0f20990cdf8357dc2c446ec6f0506c3c7a11057becf60625e60d512851519c9"
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