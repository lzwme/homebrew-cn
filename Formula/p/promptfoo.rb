require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.70.0.tgz"
  sha256 "237f6a138a17f0cdbcdc7732cb967ed21765abe3054fc13d100ff19b1d5bbca9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e699338955fab9809fa75a193348fa5c929662c4d1c773b1aff0275552e4efc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1491b65619eab5b4f5c4f3aa23c5f692caeed294833dcb24a436d07415c733c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6422e2e6f0d875f04edcf218cda262e6b7e09f17f265155c542f2914ab2b04a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "565f11660b824c2a23ab100d20652c83bb4f84a00002f012b9e2832cbab2ef95"
    sha256 cellar: :any_skip_relocation, ventura:        "4d80b1b71e99bcfaee0460b443812db10915b20240d7af141ea60760172702ef"
    sha256 cellar: :any_skip_relocation, monterey:       "9ce10d1b74a2fe0968df0345758fdb88d98f5ac607b76cfa7186df4d0beb7b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c258288d63a043fda177a593e7ee58f109298332ae2591ed483fe2bacecef192"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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