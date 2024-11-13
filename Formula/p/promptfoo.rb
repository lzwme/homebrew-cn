class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.96.1.tgz"
  sha256 "ea2ba78b94a0b9dd07bcd6d2ad55f828217c66828fdb956995bbfaec7b7c9326"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82b2a24ae9cbcc60980d05db839bf1535dbbb7063e151dfcf601ccdb5f4f6c77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "563b8e7113d7d6aee3e8c7ca56437279a1dab159238ec94335bc4c5f102af1cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49e68c3936500b1ad3eb624c0f4cfaa77e57f44a76e89d67df8aba9571c73ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "51b4d3570f0a6f39cfd8c02bf66ae32c7d0b13bd9990e4d6bc5dd08f175c884d"
    sha256 cellar: :any_skip_relocation, ventura:       "2f9c55b26926b79068ff03529f06820608079e3345c4a127ebcab05aaea12099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c8cbbc85bc722204fb33308c8b21d2a73e55ec7d73796b6ae71507eed70055f"
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