class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.104.1.tgz"
  sha256 "30454a486a65999d7fcdbb93c69c7ca9639b9059d9c24a90c95ccea97d5b0f53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3304c8d8004a13ea9a5762a094803b4f326cd5de566d04e2801f97776bb3788"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d11e9703a4b413f3d7374edb40a5f83db42477704234d467126354401c7f648"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bfd3f0302a2e1f31a4e65c355af5997dfd4c777b8b8259eecbac81fa3ebc0e88"
    sha256 cellar: :any_skip_relocation, sonoma:        "efa3b6be697cb339665d77605fd528f1cdc1970dac4697d1a1894745b9692391"
    sha256 cellar: :any_skip_relocation, ventura:       "1b863ae89e68963cab7be428427ab9170b0401776c17affc68511afa2c249bb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65574099361a603cfbcc69180e0feb7032937ef6215f8773651472cd7a1c632b"
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