class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.84.1.tgz"
  sha256 "1b855b007673cf84246c8222cffe84b1e229af4d73c528a97756d78f6ff531a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2aaef8bdaec3adac5b0b11402d4e98828f03a69badd1a50adee144c4ba485d83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba4ae8fc5d2ab74335d3aa1f147308279a3d7dc2041acdbbf8c6007ca8d8bcd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7157c0a5224a8b559e4606cc11d73a4bc2b3660f106b3f2d06df7f1705cbbb1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa90758b0d4ed74a4a2e796962d652a13066e25c0c4de7153b995700d24eb332"
    sha256 cellar: :any_skip_relocation, ventura:        "863403481d029854324434ae756c007d6480090b1eed542a67da7e2cd14ac285"
    sha256 cellar: :any_skip_relocation, monterey:       "64c4432bcae12d4eaed3a8e6349825c7aae26e9d119582cb3e3af336d751d13c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a139c0b75ade13bd13b042729507c8a4bc1d24d53d5bc064986eb8e0a5075bf4"
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