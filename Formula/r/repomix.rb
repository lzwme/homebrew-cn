class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https:github.comyamadashyrepomix"
  url "https:registry.npmjs.orgrepomix-repomix-0.2.19.tgz"
  sha256 "a30903fae40f95936229d0f385810865a40ac8e393ce476fdc75d5165979576f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "696d0dd6f8c3ce86f36909a8dace1d72b37fa1ce89e196952f6867d680c8de88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "696d0dd6f8c3ce86f36909a8dace1d72b37fa1ce89e196952f6867d680c8de88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "696d0dd6f8c3ce86f36909a8dace1d72b37fa1ce89e196952f6867d680c8de88"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9238e836aab24f2d743582deb33e9c83d8eea7fcfb15eb4954d0cc5b3fb48d2"
    sha256 cellar: :any_skip_relocation, ventura:       "b9238e836aab24f2d743582deb33e9c83d8eea7fcfb15eb4954d0cc5b3fb48d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "110900214e99c803c194b04807de20197d29c13055959a1190c39adfd71995f0"
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