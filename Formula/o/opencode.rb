class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.150.tgz"
  sha256 "151b666123d4898c9e0be346ba4d461f03fd0a5ddfc33d4ae698e2d6dab3dadf"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "85a15cecb2af4a90eb15b7727c514d819081b2637ee66f9af767c7740b6aaac6"
    sha256                               arm64_sequoia: "85a15cecb2af4a90eb15b7727c514d819081b2637ee66f9af767c7740b6aaac6"
    sha256                               arm64_sonoma:  "85a15cecb2af4a90eb15b7727c514d819081b2637ee66f9af767c7740b6aaac6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a080cb76dd3152653cd4bd3f6496a5b0016bd15cad219184a75cc8d2432a0d2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e3c52e274054caf87aa0d8c151b0e777c70458d8bf7f955fbde1157d2f12279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4875e6737517959e7ccb3660dd9875bb8a9bdbdd898a5fac6869d78fbc400982"
  end

  depends_on "node"
  depends_on "ripgrep"

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