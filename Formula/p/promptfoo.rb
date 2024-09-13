class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.87.1.tgz"
  sha256 "75b12f746d58eb4a3f121fd462f8a810a9b4c26032dac7350f547aeddbcb7ddd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5acb362d0fb2dc0ca6a1e427e4d51eb004c4289f509beb4b2d15c63477d9129c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d17d56d41321ff1071c9c9e0d76480aa1811e58b5e6b05b59f40fb0dbfde92a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f2f3accf0cb0a1fa92a4ca6305d5128a5a227493b0f2c4627978bb937e6850"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ac67e50b7373456187d7bb6646dd81061057c324c938b5ab7fff30a80ae1d62"
    sha256 cellar: :any_skip_relocation, ventura:        "46ceda7fb7edbfe6e22516148ab7d352228195b9e3596fd85a8d4346140c6923"
    sha256 cellar: :any_skip_relocation, monterey:       "bf238af9395862ae11b637351c20599685b6ef3bc2f783937b053cfb463bff84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f5eb9a19e76ca4bb346ed78df42832b7df8c4f8e6c7c41092a083c02deacc0"
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