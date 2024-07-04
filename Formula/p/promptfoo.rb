require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.68.2.tgz"
  sha256 "f1d2eeac3d44ffee23673a4de333eab0602f511e749730b23aa19cdb7c523851"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d2dc6f1604f51f788c1626b274edba380f90c66fb61489e726750cbbd40709a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e20c361c91a26c470670793f164b472fb78b3c9e2e6f0c1622a2aa1c84fbb90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64057ebceea574ec5e1ed411b1090a07136825a16973006a0ad00c7fe9c1038f"
    sha256 cellar: :any_skip_relocation, sonoma:         "4f22931a5e9ce7543d7a8d42882bba96c63d36d36885172c501b7e34f9a91db4"
    sha256 cellar: :any_skip_relocation, ventura:        "bdb99318691a51953aa7e73f5c3940db096d3340414fb071fada864e84122695"
    sha256 cellar: :any_skip_relocation, monterey:       "3d497223c413c61eaa3a17cbab81d254449053d11af53ca2bc4f9849b07c2015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "983501759dc0a54d56c64612f840d2ea369c50643f89b24392555b640e851f5a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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