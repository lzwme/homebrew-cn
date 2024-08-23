class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.80.2.tgz"
  sha256 "5edb8744371af7e71ccb099276c74dd58cce033e88333eaa5b43c26bae26219c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31c1b4242cbd73361126d75f824e6df21601d63ea59b37d5bebc30780dd081d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b2ce83de3bb7a53a41e3256cc25a620f74757e9c61ec1e77d6a99da2ff4f466"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "716c0c813d2a80787afe0d877723164b6c16783d00c98f1f35349bc17b1a2be1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0aa20e551b1ac1d646ffb37bc0e138e6b99dc824cf50f0fa5ffb71878e5bc0f6"
    sha256 cellar: :any_skip_relocation, ventura:        "385b3c60b14a7000f7871fdf60302c398134ccfe33e9aea57c4931902b97d1dd"
    sha256 cellar: :any_skip_relocation, monterey:       "9261367b464f1cabadc10c988e65b3e5a8d0e4954f2b0c4a43de708d650c4dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e90dcfc86c20399c180f7f3c610668233730beb9ea41bfeedd504fb3103b727c"
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