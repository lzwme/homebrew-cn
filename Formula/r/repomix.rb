class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.25.tgz"
  sha256 "4fdbf0354481376b0bed2dbb497d68558d4e3e0dc06cf842d1f627d6e7abff0b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "20263e9efb57c09eeea21c835420f740986bdf8f6e4116e5524a1f8196f44791"
    sha256 cellar: :any,                 arm64_sonoma:  "20263e9efb57c09eeea21c835420f740986bdf8f6e4116e5524a1f8196f44791"
    sha256 cellar: :any,                 arm64_ventura: "20263e9efb57c09eeea21c835420f740986bdf8f6e4116e5524a1f8196f44791"
    sha256 cellar: :any,                 sonoma:        "f7cecd58a36dc3b3915653afb00d2127e2ea6819df9005a27877dbef32de3f0a"
    sha256 cellar: :any,                 ventura:       "f7cecd58a36dc3b3915653afb00d2127e2ea6819df9005a27877dbef32de3f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1178407768349666fd893e8a7cb667422f75d193f99a8482639dc4cf22fe34"
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