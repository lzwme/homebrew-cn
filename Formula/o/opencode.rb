class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.10.tgz"
  sha256 "b10dea019b416410bdfab16ff8a21c99a78ea7dd2cd8684d8f1ca47bffeeda94"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ebcda8fecdd385a7f65d67489b89f428dee73fe3f3b3dd10d73a651688633b30"
    sha256                               arm64_sequoia: "ebcda8fecdd385a7f65d67489b89f428dee73fe3f3b3dd10d73a651688633b30"
    sha256                               arm64_sonoma:  "ebcda8fecdd385a7f65d67489b89f428dee73fe3f3b3dd10d73a651688633b30"
    sha256 cellar: :any_skip_relocation, sonoma:        "656a5c16185a698222cd627230f18d6338eb5251e37643a5dc57ec545522e5bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0ff06f830b479a19fbc4716d726b6221e25136767e919b354359e6ac4180560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2de102494e87bf47fb590092884f3d91123610a44430792bece6198423a07b51"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end