class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.62.tgz"
  sha256 "14dfc76c1f37b57d743d5743198b12be15a87a6cc8fc68093affd6833462d5a5"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7175fa5bc3731d642c49d01003a54a7696cecc324390eaa58bd32cec1d5ea71e"
    sha256                               arm64_sequoia: "7175fa5bc3731d642c49d01003a54a7696cecc324390eaa58bd32cec1d5ea71e"
    sha256                               arm64_sonoma:  "7175fa5bc3731d642c49d01003a54a7696cecc324390eaa58bd32cec1d5ea71e"
    sha256 cellar: :any_skip_relocation, sonoma:        "511899f63eb318ffa37eacdfff28fe34c4589076ba1e5658769262e53381dae4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2466eaa43f3028bff87dc66a833180594695f3fa2074734acb80c7b9f7c9ab36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f38ce627572ffedcbb4bf59e4954692475569870779fb4da1fca6d8effbe41b6"
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