class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.9.tgz"
  sha256 "9c4569ec539abe2338e7f1e19010ff5a620501822f7de6a81b23a23e047db746"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2b8dd26a0f62b08eef1894aba7b8b422ff3442eb012024da680fbc438ee19fb9"
    sha256                               arm64_sequoia: "2b8dd26a0f62b08eef1894aba7b8b422ff3442eb012024da680fbc438ee19fb9"
    sha256                               arm64_sonoma:  "2b8dd26a0f62b08eef1894aba7b8b422ff3442eb012024da680fbc438ee19fb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf2ca158a115090d82e5c6d657dffa7b059b6928a9fa3ed28e69fcbb7ac94a2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20f34d7e5832211b8200fed8ab15aaf0d18b1f3eaf7294cfbf67176a841c4126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "536f16482b9001d344f272515cc8bc2a46e3efd455a17e343192a59b91805b04"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/@mimo-ai/cli/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "mimocode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mimo --version")
    assert_match "mimo", shell_output("#{bin}/mimo models")
  end
end