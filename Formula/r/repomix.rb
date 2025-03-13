class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.38.tgz"
  sha256 "f1ec8b19791f05c8a6947459be58853d0d8a3bc95f098dcd6fe0c8ca46537d7d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0ab734927d746749033f347971087525afa6e6407aff557b50793509340fb934"
    sha256 cellar: :any,                 arm64_sonoma:  "0ab734927d746749033f347971087525afa6e6407aff557b50793509340fb934"
    sha256 cellar: :any,                 arm64_ventura: "0ab734927d746749033f347971087525afa6e6407aff557b50793509340fb934"
    sha256 cellar: :any,                 sonoma:        "bfe7736763c573a8513d7c9a2c01ace13ab00483e693e23f59d84e5960c21b0d"
    sha256 cellar: :any,                 ventura:       "bfe7736763c573a8513d7c9a2c01ace13ab00483e693e23f59d84e5960c21b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31061f3298afdc234c73c1cf3a6244cbbba4d1f4a3550230f35d9a377c642852"
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