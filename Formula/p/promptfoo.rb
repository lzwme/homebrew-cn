class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.107.5.tgz"
  sha256 "9489091ac5c8afefbc4b0a51ee6fc6d04d75b20a243a8f44c9f0928becf61209"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f29d938b907223965461881b578566a7c5b31d1b2a1b4faff63cac9a54ed9edc"
    sha256 cellar: :any,                 arm64_sonoma:  "303e9d867e60b4a17c860700476bea77c337da90b223cd3773eaf9c0946fa964"
    sha256 cellar: :any,                 arm64_ventura: "6315c445f5acb766b79af91d1e68945ef5d527ac799acf4719d256b4891764bc"
    sha256                               sonoma:        "eae1314271279866b3bf3d367cd61e95015dd0f187763a2144d4d815917f3f5a"
    sha256                               ventura:       "90a21ba444afcdc36ab82997c371337dd51e465ecb8acd1ebfd0e716f00779d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fe30a93bb5a6b19ccfcd9ad76554447fa108b01bda6fffb452b791fd1e5dae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9d1d133f430227da14ac5a168e59f32f1933407cb6fe425a67bdbcf824dcd8"
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