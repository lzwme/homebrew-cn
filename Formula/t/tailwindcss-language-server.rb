class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:registry.npmjs.org@tailwindcsslanguage-server-language-server-0.0.21.tgz"
  sha256 "8df99f2ef9bb68759cdfa7cf6fa3a1da10de99217a0d94f0ed55765beb3831b7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "faed41d6cf60bdd9c34c5255db344c1657f8c4b0abefa15761619163edae4426"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faed41d6cf60bdd9c34c5255db344c1657f8c4b0abefa15761619163edae4426"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faed41d6cf60bdd9c34c5255db344c1657f8c4b0abefa15761619163edae4426"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c08f1aa1d388193ae35d2c6f4686b1c6d6a82d2b4c25b2765cec398a2b6e8bb"
    sha256 cellar: :any_skip_relocation, ventura:        "6c08f1aa1d388193ae35d2c6f4686b1c6d6a82d2b4c25b2765cec398a2b6e8bb"
    sha256 cellar: :any_skip_relocation, monterey:       "6c08f1aa1d388193ae35d2c6f4686b1c6d6a82d2b4c25b2765cec398a2b6e8bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96f2ebbb8406cbe07116775eebe724abe2d4115ac8f5162f44a7e0d32e8980ea"
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