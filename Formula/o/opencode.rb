class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.18.10.tgz"
  sha256 "c135d5cb88407888f7d67ddb4a2e30f27109a8b9e8922282674b8abb34226bd8"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "5ec83284b1261092eee4988f33cfefa234f9ffc3dd3f1e9a3f764c2e7b2712fc"
    sha256                               arm64_sequoia: "5ec83284b1261092eee4988f33cfefa234f9ffc3dd3f1e9a3f764c2e7b2712fc"
    sha256                               arm64_sonoma:  "5ec83284b1261092eee4988f33cfefa234f9ffc3dd3f1e9a3f764c2e7b2712fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee03a5c0df398682e17ac9b9474afb847a4687a6e1348a7bee3b6f50d9d8b39c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05be1e1e52930dcec4cbc143afe2690aceb2e73ba2f37dd879fe442b995a1898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd922a3b8e5214cb7e7f027ad3c202041b75db1ac75795d89bd82708c056b8de"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end

    generate_completions_from_executable(bin/"opencode", "completion", shell_parameter_format: :none, shells: [:zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end