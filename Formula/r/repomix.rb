class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.3.0.tgz"
  sha256 "b81033103c8eb519c630f2aa26cfb31bd93ed7c74b0a4e8b398e07fd04ebf65f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ff45089780bab2444e4f6e25ce8a6f4018b014a6a992b49cf35e3513bca713ab"
    sha256 cellar: :any,                 arm64_sonoma:  "ff45089780bab2444e4f6e25ce8a6f4018b014a6a992b49cf35e3513bca713ab"
    sha256 cellar: :any,                 arm64_ventura: "ff45089780bab2444e4f6e25ce8a6f4018b014a6a992b49cf35e3513bca713ab"
    sha256 cellar: :any,                 sonoma:        "4b031cccdb78ad9e1212b2a11db9b91853ccd5bf7087a85cc8d440ad80f3e499"
    sha256 cellar: :any,                 ventura:       "4b031cccdb78ad9e1212b2a11db9b91853ccd5bf7087a85cc8d440ad80f3e499"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39487c5afe442ca56f50c7263ac79655926a1ae757d2bf1c5d0638f96f879e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3481639aaccf52f0fb4c9fadbdf7e8ad7edac4c59f0fc18dfd906e8916a8ec75"
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