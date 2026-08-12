class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.11.tgz"
  sha256 "f0853d56840d04940ecf53845630bd8ff215c18a1d486291c091721f1324d082"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "386eb46bc891f9ce0f388cd310904068468c4476d26d8416b7781d977e6e16cf"
    sha256                               arm64_sequoia: "386eb46bc891f9ce0f388cd310904068468c4476d26d8416b7781d977e6e16cf"
    sha256                               arm64_sonoma:  "386eb46bc891f9ce0f388cd310904068468c4476d26d8416b7781d977e6e16cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "94118a2d232c38e6bdf8750420adc00bd4c45aea65079ce17b45781eb8762b1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f4a1825edb544c4a03a40437350495ddab8a2454ea23dfd40977fcd7bd1b9f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a9358566b6aae5f54c0e35372c63d822bd710365f5598d2af3b7ce6d44daa39"
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