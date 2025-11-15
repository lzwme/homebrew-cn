class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.65.tgz"
  sha256 "5887386e46a7bc8148c42b92dbeba5d5745f8f47ed3801a2b3dc7c62501f80e4"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "31b188d043eff03addcad0aec20e1a938ee4d22cd48c8abf4de519923134de13"
    sha256                               arm64_sequoia: "31b188d043eff03addcad0aec20e1a938ee4d22cd48c8abf4de519923134de13"
    sha256                               arm64_sonoma:  "31b188d043eff03addcad0aec20e1a938ee4d22cd48c8abf4de519923134de13"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c5436d6c26b9aee1e0e37b923f9e8366443b480e9e92f9d0fc40e6136822c5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f18c171cefe461f576adb1fe8ad48848f7aa66e6821cbfa70da571be9f2991fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52cace01663a7318b71ad2d25ebdb79b1e5a3ce51d798ea3f5cecb95bab8b0e5"
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