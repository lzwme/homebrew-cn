class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.9.1.tgz"
  sha256 "780df5bf9beb227163867589a25e2630d8023b2cb77c482d50688a1db82626f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bfd5aa93ccb9891988027d19a6d6b4637e9b0bac730f96569388029f0cb227af"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlresume --version")

    system bin/"yamlresume", "new"
    assert_match "YAMLResume provides a builtin schema", (testpath/"resume.yml").read

    output = shell_output("#{bin}/yamlresume validate resume.yml")
    assert_match "Resume validation passed", output
  end
end