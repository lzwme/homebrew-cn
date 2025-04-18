class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.110.1.tgz"
  sha256 "6d9e43bcbe471df80b11480f0eebc9ac7fc51602724bef0676d6941c21806873"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9fc1eeb1e3dce11f1cdb5a3db76846ec0cefb1d01988f865c0fdfb994bebbe76"
    sha256 cellar: :any,                 arm64_sonoma:  "321e19ff68b3e6bde85e749c0ad453ce363e3daf489e7b4bb88a5c8d807d762a"
    sha256 cellar: :any,                 arm64_ventura: "d2ebf6c06363310b87fdfc1d7c766daf745d94dafa32056755bb3a32c2b8eb73"
    sha256                               sonoma:        "172ea79cee7d384088497b883f7f8f509db27578c9d8a08d3e6d515d91369504"
    sha256                               ventura:       "243504e59cd6a88efa2a083da92631e5ea84c4f4a464139efe14608f8a58b6b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26d19883b25edd0401ac734c8dfa802b73e094e4be96260b53d0d4ebe69d0f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7fb895151960a8a7636644ea03f692b1584830c857ef03c313503792d6b7094"
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