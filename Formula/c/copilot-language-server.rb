class CopilotLanguageServer < Formula
  desc "Language Server Protocol server for GitHub Copilot"
  homepage "https://github.com/github/copilot-language-server-release"
  url "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-1.464.0.tgz"
  sha256 "700af795243c9766079c5d72826802e9c249a6fd7ddca2e9faafc930057f4897"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a79530ed16f063bc28a0e01ffb7ac8ca35e7334521804651fa47b87faf9470aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e32bcb64632f2800de2470a8f8f8eca0d488faad5a9f322c76a7a7b9d23b909c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23fc8e90384f1a84cddec2463e27d52b0b494150d157ac17ba277e380f827a45"
    sha256 cellar: :any_skip_relocation, sonoma:        "77b5d02fe03b4aff143b922a372a36e1ea3a2197ae6762654b229842787c9a20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d83831a359fb43117be4bdc6e38b7d272011c5f23176b0155075e44f1411a18d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eadc030f185de81072e6261ebdf0989a2060adce4d5561ff8949f8e7bcad65dd"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    pkg = libexec/"lib/node_modules/@github/copilot-language-server"

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"

    # Prune bundled native artifacts for non-host platforms/architectures.
    rm_r(pkg/"dist/bin")
    pkg.glob("dist/compiled/*").each do |os_dir|
      if os_dir.basename.to_s != os
        rm_r os_dir
        next
      end

      os_dir.children.each do |arch_dir|
        rm_r arch_dir if arch_dir.basename.to_s != arch
      end
    end

    if OS.mac?
      pkg.glob("dist/compiled/darwin/*/kerberos.node").each do |file|
        deuniversalize_machos file
      end
    end
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/copilot-language-server --version")

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": null,
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"copilot-language-server", "--stdio") do |stdin, stdout, _stderr, wait_thr|
      stdin.write "Content-Length: #{json.bytesize}\r\n\r\n#{json}"
      stdin.close_write

      header = stdout.readline
      assert_match(/^Content-Length: \d+/i, header)

      Process.kill("TERM", wait_thr.pid)
    end
  end
end