class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.117.10.tgz"
  sha256 "e4af44f6ff6383886054bb4afc74876f1959fa3591e1971e4740477904bc8e79"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "76b7253a8398a3b5469fef216cd34cc11cceddb00678a8bf2e1759d38353192a"
    sha256 cellar: :any,                 arm64_sonoma:  "08c66181adb203504710c06d2246c28a54a9b7601a184af253bfbd45506a50e5"
    sha256 cellar: :any,                 arm64_ventura: "2c32f01016e7efa0e291c7e38fa011cfa9c2582e9b3a1e70c779263f50424d8f"
    sha256 cellar: :any,                 sonoma:        "7d43830607980a5b83453a466de91dad1ae4c8ca2d190ddefda9b5ea0a154b63"
    sha256 cellar: :any,                 ventura:       "c1f56521b272f61cbe0782a895ea534afcb2d1d8a74c62d68f5ed2dd0a972915"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a85d0425711b33d31777efc8181c4a3c42d026d600757ecbc927d6613d702192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8aa271a04146b1d749c3a3fcf7e637c0bf80a6214ec646e2647452bc84b07fc"
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