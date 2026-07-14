class ActionsLanguageserver < Formula
  desc "Language server for GitHub Actions YAML files"
  homepage "https://github.com/actions/languageservices/tree/main/languageserver"
  url "https://ghfast.top/https://github.com/actions/languageservices/archive/refs/tags/release-v0.3.59.tar.gz"
  sha256 "fc212c5d43a153920328708fff7cee18a849f4c5220f4150878796224c664938"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c4dc63e13118a2d5ebb1f27388b8cfcf76b4f750ee129aa269aef362039027f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c4dc63e13118a2d5ebb1f27388b8cfcf76b4f750ee129aa269aef362039027f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c4dc63e13118a2d5ebb1f27388b8cfcf76b4f750ee129aa269aef362039027f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c4dc63e13118a2d5ebb1f27388b8cfcf76b4f750ee129aa269aef362039027f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b56ad64551392fe947c3a1a94dc1b1de3e148d2884cbda9e5a9692086efdde2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b56ad64551392fe947c3a1a94dc1b1de3e148d2884cbda9e5a9692086efdde2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build", "--workspaces"
    libexec.install "languageserver/bin", "languageserver/dist"
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    require "open3"

    request = {
      jsonrpc: "2.0",
      id:      1,
      method:  "initialize",
      params:  { rootUri: nil, capabilities: {} },
    }.to_json

    Open3.popen3(bin/"actions-languageserver", "--stdio") do |stdin, stdout|
      stdin.write "Content-Length: #{request.bytesize}\r\n\r\n#{request}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end