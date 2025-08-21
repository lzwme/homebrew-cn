class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.117.8.tgz"
  sha256 "df73c40d5a230e1aa91ab51f06cff7c75405c631d9d856542512a971742a34c7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33f6df39bb6c70c0db0438910c17c9f6a6c98d78c3078349df31402aad292e87"
    sha256 cellar: :any,                 arm64_sonoma:  "12d3f0b0e32ece18fb2e1bf536d5b3564fbb5d34deef86c4c2ca890f3634a065"
    sha256 cellar: :any,                 arm64_ventura: "997faf75315687fe971dafb1daa7d8696dea3116e6388435600374d31f3a2300"
    sha256 cellar: :any,                 sonoma:        "0d315bf4c1fda8cc0cc1285f14fe3db153cbec4007e98485a1e95268cd6c3df1"
    sha256 cellar: :any,                 ventura:       "e0cedcf99299d6648ffee68dda9cbc78ba5411acf7f3fe4a6a7e60504c80758d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aec62da0440769b5b941b601a2d866c8b0c46ceb120c97f989a2dc64a35b1595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52731a2b7304f982c61ba6fd82d5b185ed404576df406fecdb5e21b8a3b2666b"
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