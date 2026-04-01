class CopilotLanguageServer < Formula
  desc "Language Server Protocol server for GitHub Copilot"
  homepage "https://github.com/github/copilot-language-server-release"
  url "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-1.461.0.tgz"
  sha256 "ace151315e49b148d1c62df8be853056833b7287cf93ffef45f1deb408b345f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b59fcd64e3b559a49df6649b6aad57ecff8821c3941e70bad7ead9d38197bb75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e1143575203ba8e906e5aca07c2740fd500c1835cad14b8d266b33aaee999fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f574b8fe2341bcb802a90bbfb689de21a4348cb96601d067c874d9267c2cb2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d4104f18fbe2f7a70f19e847ff448833e6a500049bc44f169995bf287eafbc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9632e66cee79a446a01eb90d910b0153d37fa32c0ccea9e07bc819f56cc9104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a166747ce621043ce88c9fc92079478aeedcf9baf97b59749a4a16235efe8879"
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