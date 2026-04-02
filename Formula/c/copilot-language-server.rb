class CopilotLanguageServer < Formula
  desc "Language Server Protocol server for GitHub Copilot"
  homepage "https://github.com/github/copilot-language-server-release"
  url "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-1.462.0.tgz"
  sha256 "a13a1b01a574f2b32bc8a294e33c703c704f0356cc4657aa268e43d1cecf66a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e31a44e33915ec1fd585571846e16586114bd0bf67aa1dacb2ec9f217b8dfca9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eb5e7e5eba32ffe8b17710e93853dbf2025efbafef230aed71c36c8a2a1c400"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b2af4ee3e912c13e954c2cd7d46ec395fa0671508d5b216af169fa5f1e6bb1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd360230bc13ababf64afeb802256088c3354051fd6ba0d59e488577665236c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "429ab2dfb08baa2d234ab131170defa2df1fda836df1f5df7dedbd585d29818f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0c3e3e1bcd0eebe804db0a3e3aa82abfa961a99815c3fe1d0e14deb01971251"
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