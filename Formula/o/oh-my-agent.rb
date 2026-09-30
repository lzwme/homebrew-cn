class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.0.6.tgz"
  sha256 "8bf6385514928c181c6bdabb09037ceb2336c451fda1eb3ba496f857d97565b8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3fe035efc463a89e630e16ec36acd80f2b20393d473905151fb7d2207504e041"
    sha256 cellar: :any, arm64_tahoe:       "1dcd39f4e0dc54bae82e0db7c5487c61985f416f7a1c40976ced518e5d47bf6d"
    sha256 cellar: :any, arm64_sequoia:     "ebc58dec1755a82daf1b9cf453d655fc3dbdb364e1904bce68302ad044822ba0"
    sha256 cellar: :any, arm64_linux:       "db467764070d56f09d4af30d12ad9daaac123798f486edb11823d97227f83130"
    sha256 cellar: :any, x86_64_linux:      "e908d05c350790b97b37ca2511563399a77d0a979011b4fee22f0f80d6b31177"
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