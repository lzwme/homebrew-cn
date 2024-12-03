class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.99.1.tgz"
  sha256 "65cf68492b9559fe1b9f1be2c074f026419b46e8307b92bcbde7c715b46535b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a213e075341950940228d6d30de1e36aabdf31aa53af21016fc0ea563ef46547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13d5ddb62035718c4d278862924950b986d4500b98340b403a1d927e71ab9b44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b38dab8e4afcd7c251cb6ce33e081058455d3fca1f123720a197e71cd0676ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "855655e9a11cb1edccc17622855f21ff6548d8e07a6a95864b60ece297b044d1"
    sha256 cellar: :any_skip_relocation, ventura:       "7bc67ad979d4d83fb939ed3105d73ea47225096a55709f476aa815661b7729ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77be76e540df10d6b1c2b7c597c7ec285258c7a0859159469da31a2715ac9b45"
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