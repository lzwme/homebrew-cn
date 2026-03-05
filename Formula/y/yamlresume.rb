class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.11.2.tgz"
  sha256 "47f4c069732fd88b9d7ed7698e6cfdee98c9685cd897ab5ac118202d54134de3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7076936c6fdb278f1d0c2f68aeeab156c562ca3d2ae09a9078c524ff177de4e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fcc2a155609630fa9d4e1e788e06eacc598d72abc6542af5537e1e516d968ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fcc2a155609630fa9d4e1e788e06eacc598d72abc6542af5537e1e516d968ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "12c1e1a96f047a3eda1c7d59619b98136f6f70802bfb5845911fa899aff312a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdaf75d00dec84a8890a351e25460f2690a2dbaa48fb28f19b1e0e5c41637b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdaf75d00dec84a8890a351e25460f2690a2dbaa48fb28f19b1e0e5c41637b54"
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