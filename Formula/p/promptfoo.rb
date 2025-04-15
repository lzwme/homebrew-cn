class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.110.0.tgz"
  sha256 "df205ad81c894d34dc2f95fd131b48ad581533a9223e9804471c86d5e94cc953"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ba72704c55171de6574b5b3f9b0a35f472e26c52a6f1350c4543fd3f5df595f2"
    sha256 cellar: :any,                 arm64_sonoma:  "4af83d1eaba905b1e904947ad70f90d14994279307eb3007d27ef278fd110c50"
    sha256 cellar: :any,                 arm64_ventura: "64e447e0fabfa0719c2aed5cff1665354b59180ee8745170e97c4b8d25de96a3"
    sha256                               sonoma:        "59f55ccd57f15241dd2fe2eb7d7355c824617c04b4afb22d982a808fcd289ca2"
    sha256                               ventura:       "9deed22aba985fe6a52bb3883dc580ae8f8dde70707316fd9a079b08e76a3a47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f799d130a2a57169a44b3e35651ae8cf1db3b88b2ffb4222db225609fd7f663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b0f26ec8da291cde16f95d310962d145d733f8e5f8d83d59e7d814cde4fd04b"
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