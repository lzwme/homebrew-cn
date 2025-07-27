class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.117.3.tgz"
  sha256 "34c3adf27c4e2df71104ec2656679a73066d66a3225ff99be537e76dfe126085"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27dd0c36c0965ed335f5ad4de06769f600b9668f7d385fc9a9e98ef46874a6b7"
    sha256 cellar: :any,                 arm64_sonoma:  "ed7a0a58ace4f60cd6b499436bceec8d9e554c09682b358f152ddfc6c492c725"
    sha256 cellar: :any,                 arm64_ventura: "78240d96d9270d48553316aff704b35d9acc2946dc16cd05e2d47ba1dc88a56b"
    sha256                               sonoma:        "9f7415d70d0b9f4e99ee26a01ebcb6169e31feb09e840ac89842dfefb017050b"
    sha256                               ventura:       "12ea9caccb04c760287a07b21471fcc2151bb82989f3ff6e656af475ba7e9bca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff7477464124c4209ee5ec3db1d7ab5f016481001adaacd45188926fbe91a74a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5576fd83000d389b81d1004bd6c97fa17cc259fd079d13239d6a572d5cdb9972"
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