class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.7.1.tgz"
  sha256 "addd7013e25dee68b549a03c3532778b9e4b75cc513fe599825dd6644f97c8d2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "22454db13a5ca643023b61e76aadc1420596d18d54c6155ea9f80f18befb8ec9"
    sha256 cellar: :any, arm64_sequoia: "30aea5a62967b6d9333a5e24d2abe19da2bf913ff083aa2dd41427715f11a52d"
    sha256 cellar: :any, arm64_sonoma:  "84f40cf38422dbe948d370be37aca014ba278fc00591cf702ed95041332fbcc2"
    sha256 cellar: :any, sonoma:        "fb70d9e2288a2012c49dd4a79465f3279c400cda593091d1979177e8cd5262a2"
    sha256 cellar: :any, arm64_linux:   "e79a807d9e2d4e880af59ff67a1578866c570804f9c73a87dabce8fef153b9be"
    sha256 cellar: :any, x86_64_linux:  "4f64e69bd765a45882f47d2b437a70d1dd8ecb8a2cbee04f76bbbf87aad5d34f"
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

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end