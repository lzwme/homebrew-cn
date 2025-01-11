class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.7.tgz"
  sha256 "0edc40141c84055411e7ce7b8a9f73da0f088c067a79e55c5a0de26e78bdfea5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd5a376f821143b1c7bcc33f16fa125a612bc20d1d9adbb270eacac88a39af45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae9ea02bcd5abca9584c51d40a621d38aee0b76f6eedcb07187312007f5a0702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1b8a93e0ab6db094db281031cc09baacbf73a82750eb1a665ab309a0aeb2fb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "29e7f65514073b4c322b14e588d35bc57e44580649128dfb066de328f87368c0"
    sha256 cellar: :any_skip_relocation, ventura:       "707d80496d165708a89d3ce6298dd0c9cd9e86d9ce09d3d8925e27ee18bbdb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef9fd24b5a1eb061516b388d4db89cca4de564b5e4c9be912d011caf21fc823a"
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