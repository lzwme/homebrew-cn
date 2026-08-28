class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-12.7.3.tgz"
  sha256 "4f14162ee20d849917b01a17ee58e1c74cd2eca49ce424808d56f866de2bef26"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "54b99d1be714b8b6d82c756451e49a3fa989d661473ee76eb62a59b5b389a052"
    sha256 cellar: :any, arm64_sequoia: "d7c5a1bd61a8a1ccba4c1d335b8845cf380c079fa051c1c0f6d7d540b6350d85"
    sha256 cellar: :any, arm64_sonoma:  "8d31d8ba04141ae2e186cb3829b0660221918790be0f622584dedcf1d2d2d7a5"
    sha256 cellar: :any, arm64_linux:   "0864d570cda282a6bf373c1a5122b0970c6f8fb92c7c96a5265121bc40220a54"
    sha256 cellar: :any, x86_64_linux:  "d3d5deec9f3657774300d7a393f9df7770653ce2fe66aec2c1b8a746d85af0f2"
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