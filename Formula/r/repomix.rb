class Repomix < Formula
  desc "Pack repository contents into a single AI-friendly file"
  homepage "https://github.com/yamadashy/repomix"
  url "https://registry.npmjs.org/repomix/-/repomix-1.10.2.tgz"
  sha256 "bcd839afa1e9c874d85f623a007a16132908d3b8fba54d34068ffd2396df5a17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3265a9862ff20b4d00af08c484bb58d70de03f10ceb74a0f227f4254adfbeb34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3265a9862ff20b4d00af08c484bb58d70de03f10ceb74a0f227f4254adfbeb34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3265a9862ff20b4d00af08c484bb58d70de03f10ceb74a0f227f4254adfbeb34"
    sha256 cellar: :any_skip_relocation, sonoma:        "3265a9862ff20b4d00af08c484bb58d70de03f10ceb74a0f227f4254adfbeb34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7e1df1971cebe672474f48d739bb326fa562781981185cee7112f27216d9c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7e1df1971cebe672474f48d739bb326fa562781981185cee7112f27216d9c25"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    clipboardy_fallbacks_dir = libexec/"lib/node_modules/#{name}/node_modules/clipboardy/fallbacks"
    rm_r(clipboardy_fallbacks_dir) # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/repomix --version")

    (testpath/"test_repo").mkdir
    (testpath/"test_repo/test_file.txt").write("Test content")

    output = shell_output("#{bin}/repomix --style plain --compress #{testpath}/test_repo")
    assert_match "Packing completed successfully!", output
    assert_match "This file is a merged representation of the entire codebase", (testpath/"repomix-output.txt").read
  end
end