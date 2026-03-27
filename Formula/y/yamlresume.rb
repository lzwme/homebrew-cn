class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.12.1.tgz"
  sha256 "07a9b6abf57021925f883239901167d87af8c26910245f6ad6b67db8a1b0018b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d1edd2388988a2755f2c90b0b6459b4454c221edc35e7ed58d4559e00cc3c6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7612020fd36ca212c1f54113fa633b81c263281fbc571e912cb3e52909a7af7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7612020fd36ca212c1f54113fa633b81c263281fbc571e912cb3e52909a7af7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "76cbda53ee597b2b740d491b810c46495f5965f3086f429f3df7841718846626"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13ec971a7a9e5f4ffcc50607c2e32ae4e914e9dc818dc77c4d39622b21598068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13ec971a7a9e5f4ffcc50607c2e32ae4e914e9dc818dc77c4d39622b21598068"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    node_modules = libexec/"lib/node_modules/yamlresume/node_modules"
    %w[fontlist fontlist2].each do |file|
      deuniversalize_machos node_modules/"font-list/libs/darwin"/file
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlresume --version")

    system bin/"yamlresume", "new"
    assert_match "YAMLResume provides a builtin schema", (testpath/"resume.yml").read

    output = shell_output("#{bin}/yamlresume validate resume.yml")
    assert_match "Resume validation passed", output
  end
end