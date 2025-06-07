class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.114.6.tgz"
  sha256 "bbd7dcca55fbc7a1f8385b93c343fc91b3615c3bdb2d16fa08b7297e74e96a63"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "66878964500a154147261e885765eca7bd2b9e06ebc3420c554afb3e78078e4e"
    sha256 cellar: :any,                 arm64_sonoma:  "f7ff5c564c44d8e51f5448f967919dbd04e792b12930ec3f624e8ccd5690457c"
    sha256 cellar: :any,                 arm64_ventura: "8727de1c54366cc748eaf0515dfe67bcbdfc2234674065165fcc06702c52f40b"
    sha256                               sonoma:        "f56e1d960933972f5a1346eb2a793cd83d40434e12e220caccd1e45f4bfb3521"
    sha256                               ventura:       "d32ed4d0af6c914d3340b15c4c44192883a42ce21f5bb149134089c0b7c21d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "442d0f6972ce495e519957f7dd51eabc6b81dabf175d29e17f59eee1fd2f6e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "660b827ed8702a76e7db4797bf15235271f2d1f9ec58029610f9874f3ae75fb2"
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