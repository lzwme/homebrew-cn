class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.106.tgz"
  sha256 "4bf7318bff006d35906b3ab243c21c3b860e98b5b13b3f62a58a5db5cc56f9a5"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "45bd534eed7514e063c83eb83d0ccd03eefcbe8f9b2e45d6555576ab27c05cd7"
    sha256                               arm64_sequoia: "45bd534eed7514e063c83eb83d0ccd03eefcbe8f9b2e45d6555576ab27c05cd7"
    sha256                               arm64_sonoma:  "45bd534eed7514e063c83eb83d0ccd03eefcbe8f9b2e45d6555576ab27c05cd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "49791d5a3ff2bf857a2e5243ca3f1a3b294d7f9e00e1685de0ebc92640c4fd16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dfefd573fda5a9e476ddcc7253e815bc1663055d315411b6e4ce8592c894a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c41d9548187e33f5607cfc8f45c2e8c0a74e65560e40a622cb7e76ddb49d26e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end