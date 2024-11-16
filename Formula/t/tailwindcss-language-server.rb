class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:registry.npmjs.org@tailwindcsslanguage-server-language-server-0.0.27.tgz"
  sha256 "d3c5f6c11ffcd8c7dc79a4d9d2e6d41f7d121ffd1a1fbdef9abc8faadeabff87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d949c179367bba3099db932a32049dfef834e77b8484c10f6b620ecadd2ca1b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d949c179367bba3099db932a32049dfef834e77b8484c10f6b620ecadd2ca1b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d949c179367bba3099db932a32049dfef834e77b8484c10f6b620ecadd2ca1b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "613776479bd1a49ca55769553852a133e69fec0d1d977bd62f0e396cac5754ea"
    sha256 cellar: :any_skip_relocation, ventura:       "613776479bd1a49ca55769553852a133e69fec0d1d977bd62f0e396cac5754ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9e3fe9f2283f71129fb5d715eaead6677ecf6ab9ded712eb69f3ceecbe300d9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    (libexec"libnode_modules@tailwindcsslanguage-serverbin").glob("*.node").each do |f|
      next if f.arch == Hardware::CPU.arch

      if OS.mac? && f.universal?
        deuniversalize_machos f
      else
        rm f
      end
    end
    (libexec"libnode_modules@tailwindcsslanguage-serverbin").glob("*.musl-*.node").map(&:unlink) if OS.linux?
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin"tailwindcss-language-server", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end