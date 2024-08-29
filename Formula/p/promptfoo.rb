class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.81.3.tgz"
  sha256 "d4e03c675b71239d5b069dfeaaaf0efa6c290e56e4f5d540a521b90149e3d5be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0dd6815709769d6ec6f678d4523dc15f12993b42690cc95dbe08eb99b93cea32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41494b4a47d5d437f0ef72a8a2ccd7631414e154f019c41917ed08e47243db34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89215b603ccef85e54bd1c779b8a12cea52db9bfe91e354e0b16f3b88c7efd6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "25e79557bcbe0c07b898a560b925c6da4bc7b154501990a4a2454f6eb15e7950"
    sha256 cellar: :any_skip_relocation, ventura:        "c021ae099293ccc84062add356b086fe2c7b4820533bad353f536659c55011e2"
    sha256 cellar: :any_skip_relocation, monterey:       "7fd0898b8b4de2d32e5565cc1da2e3aba1ffe273aaaac0e22defcc6dfc64578e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0de23144d46cabfc3e82187504312dd85721dc1279cb5fff29208e2c981195be"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end