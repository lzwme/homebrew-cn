class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.93.0.tgz"
  sha256 "d7e4ca82c50c80ff91dfa76e38b76586629127a06484786afc08b1d94acefb2b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30573e46b7dcd75c9003cc949b2c27103b9b44581c99de4f127788f95c1e2720"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203fd0c7c88153b69310e11aabbca2f325ce645a5d20a193813e8ffe2103108f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73ec3ff4783ce826319ec20b4168b77f662a019ba79d56a4eee293b3e5e8cb94"
    sha256 cellar: :any_skip_relocation, sonoma:        "0156994464f32a2eefd827787b2f4a951eb8951740c93fbd4d6ae54768ee9a6d"
    sha256 cellar: :any_skip_relocation, ventura:       "6362b17a7841893d67d399cc54e03d92018c7b073f717fec0fffea81784aa8b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b353f9f8c545fb0f8956ee668d958cc07a441310622eecdfa0bfc983ed3c805"
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