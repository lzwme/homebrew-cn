class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.117.9.tgz"
  sha256 "8b6e9ed9fb1bffc2e80be2f8f910c5c868a69c6e2f80d1515ba16a1e7cdabc11"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "09554969ee708c719d509064dfad6506ac392778ca6d6942debc5900ffefcaa7"
    sha256 cellar: :any,                 arm64_sonoma:  "c8af62de7968dbfe5917bfd95103aa386337bbb04c64744a00aef700b54c3712"
    sha256 cellar: :any,                 arm64_ventura: "5ff34f160620b95450322ebb581e6cd2d04c00b4f0d25c178b7339abf3f85af5"
    sha256 cellar: :any,                 sonoma:        "7143d367ee99055bd1f20059b610e2d8f695a7a2b8f3590d622484dbe6fa0764"
    sha256 cellar: :any,                 ventura:       "9740a9116fca4a515c91d3bcd9c67212a927ba8b1b95f88af08ca1d2153f32e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bec6d4e79c8b2aad3eee86d0b306b37a15ed01b753f4583e2f1632c9b1f8aeed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52bd78828973abc88b6a882c1672d3ef67d704764451741353ffe01ad09a2968"
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