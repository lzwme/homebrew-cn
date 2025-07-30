class MermaidCli < Formula
  desc "CLI for Mermaid library"
  homepage "https://github.com/mermaid-js/mermaid-cli"
  url "https://registry.npmjs.org/@mermaid-js/mermaid-cli/-/mermaid-cli-11.9.0.tgz"
  sha256 "a0c68fe6db99308c360a5d2be3d87cfc15f9c967c7bc838a691804e479f39d0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fed16e2660aaa5ac190a3b6adef1cea7c6f531b11398b1981268e46fb8964104"
    sha256 cellar: :any,                 arm64_sonoma:  "fed16e2660aaa5ac190a3b6adef1cea7c6f531b11398b1981268e46fb8964104"
    sha256 cellar: :any,                 arm64_ventura: "fed16e2660aaa5ac190a3b6adef1cea7c6f531b11398b1981268e46fb8964104"
    sha256 cellar: :any,                 sonoma:        "f61d4d96eeb7230461b4d27c9bebb8d272573ffea0e1da8742e022a03e8c3d63"
    sha256 cellar: :any,                 ventura:       "f61d4d96eeb7230461b4d27c9bebb8d272573ffea0e1da8742e022a03e8c3d63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "395fdf1a7e9220510f636d9eba7e0cc6f6fd6fc1bfed02c20f9b797fc5b7c379"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37a57110fd7faec00784f4ae17210bfebeda522eb0d4acdd0cf587de494a139c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/@mermaid-js/mermaid-cli/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mmdc --version")

    (testpath/"diagram.mmd").write <<~EOS
      graph TD;
        A-->B;
        A-->C;
        B-->D;
        C-->D;
    EOS

    output = shell_output("#{bin}/mmdc -i diagram.mmd -o diagram.svg 2>&1", 1)
    assert_match "Could not find Chrome", output
  end
end