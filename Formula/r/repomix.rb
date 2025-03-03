class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.33.tgz"
  sha256 "a3be73b3fc789bc890b0e1751c1bc7c3a9c6215452306bfcc0f5000c04dceb5e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e706b3d5a99984ae59759151ace642d1a4a491c1eb579fd8f49df3211e75cb5"
    sha256 cellar: :any,                 arm64_sonoma:  "2e706b3d5a99984ae59759151ace642d1a4a491c1eb579fd8f49df3211e75cb5"
    sha256 cellar: :any,                 arm64_ventura: "2e706b3d5a99984ae59759151ace642d1a4a491c1eb579fd8f49df3211e75cb5"
    sha256 cellar: :any,                 sonoma:        "d536388abef48a7208cb8b491c0f76af50e5cae5e6b29b1ce2c7f421318cb608"
    sha256 cellar: :any,                 ventura:       "d536388abef48a7208cb8b491c0f76af50e5cae5e6b29b1ce2c7f421318cb608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e6b874d996cc30d0c9548aeaf92a2c54d8c02595515f91045554e5676969dae"
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