class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.77.0.tgz"
  sha256 "5a639b32cb0f1bac91c1d24fb62a9ec17095cd7e8092a3d9c2e0a2c6a012ad29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dbae7a4abeb737c832e8991af74f36450c6f8d15514faaa85bec75226528212"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f76d020554c56355649a3ef1ad7ac5a8224c362aadfc871aade4cffdf07be5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd4f8f5ce600ee7cdffcb280da78cca4215c9b62b4366d64b00d87247c60ea2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "85510a10a04f1ea065b7de5b710f809e0ef3e0734fa7b4e372351fe81d150a61"
    sha256 cellar: :any_skip_relocation, ventura:        "8f4f0a0d0d6e1c0e7902f23614b4506189611c484b353510b925f61b9393a334"
    sha256 cellar: :any_skip_relocation, monterey:       "5d996ff0f6093cc4794e3f9ea3fa91ccebae7cdf068dcbeb54220d37fe0740cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7a681f8a575a882fae02637028a0a66f4dedbd915f59323685711f2d8637af2"
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