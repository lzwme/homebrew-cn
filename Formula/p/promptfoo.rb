class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.114.4.tgz"
  sha256 "9f1361dd2af0239e43a6fb542e1fd3111febfff4808d8834261e92c15a9ee69e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9d9f1f9c2af280a8b01412159ae17681b73d1a73a06cbf20e24fe67619bc0f4"
    sha256 cellar: :any,                 arm64_sonoma:  "9a16fbb201ca260bfcc5afea23b40aefa1f2d8b56d3ca6a4358eec421966ea77"
    sha256 cellar: :any,                 arm64_ventura: "1b0beb8b6486660e78fad35709c8cdd170b831bf4a9259828a95dd0a6fc40188"
    sha256                               sonoma:        "23214641783ee6e624e5c73b0c050d9170577cf2b25d63512e2df1de37c6ca38"
    sha256                               ventura:       "90ea572338bd11284c04e986d367b800fd3d3f960047b15d30b4d83c943125d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faf8446396eaa57b95f3bf36e572ffd6351bc156b5833aec948f492b1607b78c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5e0483cc26328f72b07bf95ffab77e294afb5b979c2c8b9dec9f84f737ad5ae"
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