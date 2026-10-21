class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.7.0.tgz"
  sha256 "a34fab3a125335cfd16ee8f96f8c653c0126c58873076aba36d9a967c8e2f59e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "51f7c604746773702bcc321ede91dde1cc39836b33ffef3585b8096d933e047d"
    sha256 cellar: :any, arm64_tahoe:       "e2295b093ed571089a81900ccbd742f9f593c23f6e4deed67175c5b5017778d3"
    sha256 cellar: :any, arm64_sequoia:     "5dc95ea31bf288a2d93f7cab7322b1936ae79c7ab3663b8ebf6723d7f449f999"
    sha256 cellar: :any, arm64_linux:       "7eb2b52bb4bc8463258f1b3bc401ee1c8b3276e13046d19df183b3d8c545a60e"
    sha256 cellar: :any, x86_64_linux:      "a0305e11ca6aa7e982fbfa78e729969f5c0e84459f45c675b162475b2bfdd413"
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