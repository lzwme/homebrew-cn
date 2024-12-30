class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.8.tgz"
  sha256 "02d809b348f86544a1eefdfab542d706076ff3dd0fa4ca8005466e77b95c861b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a34de055531e1f8c5a36132147de14e33f788523ca378a646d1002f2d2421f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0a34de055531e1f8c5a36132147de14e33f788523ca378a646d1002f2d2421f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0a34de055531e1f8c5a36132147de14e33f788523ca378a646d1002f2d2421f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ae190406d0310ceb7a4f86bfaaa4f168130cd848b27e7ad7234ca7c1ca5ba02"
    sha256 cellar: :any_skip_relocation, ventura:       "8ae190406d0310ceb7a4f86bfaaa4f168130cd848b27e7ad7234ca7c1ca5ba02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3958c308648a4eab2f4219fcb013805935325efe68641bb1aa7225629060a32"
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