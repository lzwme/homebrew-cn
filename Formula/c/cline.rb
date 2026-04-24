class Cline < Formula
  desc "AI-powered coding agent for complex work"
  homepage "https://cline.bot"
  url "https://registry.npmjs.org/cline/-/cline-2.16.0.tgz"
  sha256 "b1d192ab08c4981a41987dda8717c15fdee315462e7d1cfe5d573646f627d715"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7621325c4001d6c2c5d165db675a6b04a2f8556381e93e3f643742eb781f3518"
    sha256 cellar: :any,                 arm64_sequoia: "4c523a605bb0d767f8080c5b547960887ec79c0de8135442ae7410277fff1e8d"
    sha256 cellar: :any,                 arm64_sonoma:  "4c523a605bb0d767f8080c5b547960887ec79c0de8135442ae7410277fff1e8d"
    sha256 cellar: :any,                 sonoma:        "71f181f26952881c0523f895284a5abd7c17cac342eca58bd6931140cb706cb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c40d7fe1eeb8846a98cc1dada1a0479a57091aee9ccf2e2ddd0b65ae021b8aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0159a34837a00a59ed3aac190d666843c3da81d62ab413d3956524377a23e37a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # https://docs.brew.sh/Acceptable-Formulae#we-dont-like-binary-formulae
    app_path = libexec / "lib/node_modules/cline/node_modules/app-path"
    deuniversalize_machos(app_path / "main") if OS.mac?
  end

  test do
    expected = "Not authenticated. Please run 'cline auth' first to configure your API credentials."
    assert_match expected, shell_output("#{bin}/cline task --json --plan 'Hello World!'", 1)
  end
end