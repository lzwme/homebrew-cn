class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.159.tgz"
  sha256 "ad32d223aa3cef08be9c7a41e995b006851c90d99284bd79c309249881a87e30"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7536ace050513cdba0d938cfe69b6e2b68c2409f4cb60395c2e1bcb9fbf90d70"
    sha256                               arm64_sequoia: "7536ace050513cdba0d938cfe69b6e2b68c2409f4cb60395c2e1bcb9fbf90d70"
    sha256                               arm64_sonoma:  "7536ace050513cdba0d938cfe69b6e2b68c2409f4cb60395c2e1bcb9fbf90d70"
    sha256 cellar: :any_skip_relocation, sonoma:        "053d44f2155a1cd1389bcd3db5fca49a4fb94a952055dc6fae605a564f745366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9c158a1df771bf1c138b4774a866bbbfd3dbafc2e54297e6d7b5fd310aec43d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffbdc94fb4d95ac7f482cf049e6cc3a786951e69657d1a243c3849c87c310ebd"
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