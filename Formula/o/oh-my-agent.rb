class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.21.0.tgz"
  sha256 "e08762ea34fe8fb3efd0bc077d455e8dc99f7188a6dd8a869732e34655a33d1a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "885a598afcdb1e12dbe3b96bfda4e2587140651d7ef5bc072733399ddfe8a230"
    sha256 cellar: :any, arm64_tahoe:       "2e192e7514d0f2dece48485739814a895dae5792afc3dcc6ce71dff2aa4015f1"
    sha256 cellar: :any, arm64_sequoia:     "147c3300ae90168751ffabdfaed8ba041bfb2d4afb9f843246dd48827919db66"
    sha256 cellar: :any, arm64_linux:       "0193cd8f0f98b91d91647d4b753333941ff21bb1c6c62aad2526aa6fac787f72"
    sha256 cellar: :any, x86_64_linux:      "e0ead8fa052ad60a162e46fdf9ac95e676893c41ac3097df84e5f686f02e4d9e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end