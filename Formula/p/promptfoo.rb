class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.74.0.tgz"
  sha256 "2a36080017f46247750d8b97ed0126ac9651b2d5accdadbc3cd03216bcf73337"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5b621b887637772bb6e88716c40067c43c8f4c555cf388d6c8074fc319c1ae9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63ed81448d2848b4df5ec815b9392e1dad5f2d26a0f7b904e35a91ff880bb208"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "541d92848e7b55493e10bf3c511b3feb914da0fa67dd67ca08d087440861cfc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ece33cd04ba5cb896078c6125e329e59bd614ad142072911bdd7bbbee1f67f12"
    sha256 cellar: :any_skip_relocation, ventura:        "aab3d9209f7a0c989cf6c989c7bb4e479a20b09ae4a993fb6e39e51ed9a405a5"
    sha256 cellar: :any_skip_relocation, monterey:       "0c27046dc7e3953bf01a2dea9ad0b583f13b464c6c1295f6e59835026fe1cb04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37e42e605f72965028114be5756c27f396f198c667aab16a00858122527be7b7"
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