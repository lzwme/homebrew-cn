class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.104.4.tgz"
  sha256 "136eb314ea2c0ac3edd24657bb71c3af93068608028fc373067364d58c5846c8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5959cf06e9ea593b2f329384165bd78aeca36b26da5ccfa3424f7e29593ac825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75f314a0cfe7b26f3c8f2db4bd33cfcd53ec6356454258f5d075a9de611532f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d03ef18c7fc062b20b8558b40fbfd320869db11b015f34d85a257499e1c0f0df"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cfc52f77b931a00d7553544654700afd1ae5c17b36ba89d402ae48af954d98c"
    sha256 cellar: :any_skip_relocation, ventura:       "0f99e0080d29d03dda6658c1f1ffa50366e850111e2a23fb24a7162ba4f602eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97eed928d8911467e06a5ed5910a3d79034e3df39473b0e5ce4b68557378fd79"
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