class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.113.0.tgz"
  sha256 "a89ff507d88dcbbf281eb10716b539bedc9b265f3b9e8e2cc2e584cf55cd91cb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "11c5bbd683cafe4080e30e4adaaf512477ffe8dc95a265c4b965aaa8a50192bf"
    sha256 cellar: :any,                 arm64_sonoma:  "4b5768f014330c820f9a9cb7e0e9ca1fd8d0a3795dce65ea0f46b9382ec03c5b"
    sha256 cellar: :any,                 arm64_ventura: "4b113623c8be5fc81d59a8e0e440de6c6ea119fb8035a7b9e64a2b2d25ea7b6a"
    sha256                               sonoma:        "0d56515fd61f30f5768c3b24790deb1be0cac3556183efeaaffe467c5a4f7e3c"
    sha256                               ventura:       "df9d21b2a39139998ae4a4792fbe6bb6fa95d21296f37ff64afe3638989a6719"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fe0e7dc67281b88c8b03be62142509601cc47eade9313652e7bb8b35840e57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4af5f7434b258085876334c170c7e733179f33006743459f956b1568c6a932c0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end