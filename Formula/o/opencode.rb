class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.18.5.tgz"
  sha256 "e86ed5a01d91564b6b02c360a752695b1910def48db28a63454a49b78b5f9c43"
  license "MIT"

  livecheck do
    throttle 5
  end

  bottle do
    sha256                               arm64_tahoe:   "d2d3bbba9dd93c19d4b80da893a5e5eb8192918bd517836eb1cfdf49a7fb93d3"
    sha256                               arm64_sequoia: "d2d3bbba9dd93c19d4b80da893a5e5eb8192918bd517836eb1cfdf49a7fb93d3"
    sha256                               arm64_sonoma:  "d2d3bbba9dd93c19d4b80da893a5e5eb8192918bd517836eb1cfdf49a7fb93d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d67155149ac07c46bdc08bf05ba17bba15a1d88329956580a72fe80dd9dde33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13f6c0acf85c65461413df513d67187ea9b0bcb6f05bf416f5989fdcfc6f569a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a044e00a01d84f867ff471ccc2ab51616b107618788b1166b6e5ea196d5634ef"
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