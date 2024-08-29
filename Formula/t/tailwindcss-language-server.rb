class TailwindcssLanguageServer < Formula
  desc "LSP for TailwindCSS"
  homepage "https:github.comtailwindlabstailwindcss-intellisensetreeHEADpackagestailwindcss-language-server"
  url "https:registry.npmjs.org@tailwindcsslanguage-server-language-server-0.0.24.tgz"
  sha256 "377aa579f880c010a9db66a08f8f8a5891576b29716ca05abd738e8eda991c22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d83f7af6f855d86debeb06e8b6061d569350f9a0aaa23423a3f13621c4c791a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d83f7af6f855d86debeb06e8b6061d569350f9a0aaa23423a3f13621c4c791a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d83f7af6f855d86debeb06e8b6061d569350f9a0aaa23423a3f13621c4c791a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2642d096da519939bfb387f2b10176af0ac866161eccc4ecd9580ea029244c9"
    sha256 cellar: :any_skip_relocation, ventura:        "d2642d096da519939bfb387f2b10176af0ac866161eccc4ecd9580ea029244c9"
    sha256 cellar: :any_skip_relocation, monterey:       "d2642d096da519939bfb387f2b10176af0ac866161eccc4ecd9580ea029244c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "524306dd0da5200a7f463025766be01a5a1793a8e3784ae1a351816bcd72170f"
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