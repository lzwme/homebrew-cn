class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.115.3.tgz"
  sha256 "ec184b8814c7ef0838bebbc2d9c89308d54647911994b47d4f3c3df89b471c71"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "243755588787e4aeedf9121b4f306b366e8784304eeaf94d7a567d2baf992115"
    sha256 cellar: :any,                 arm64_sonoma:  "9333e3d4fadda4055898740809c654681c5d5a85eedcd25c77f559def611ca34"
    sha256 cellar: :any,                 arm64_ventura: "5431777bd56a23d2b5f316b521ee7c20a62abfd253b68d706accbf4d302a3ba8"
    sha256                               sonoma:        "5684329fe226b5bc5baddb7560bff681a770a99cc5b1308f56fa6644e75021e8"
    sha256                               ventura:       "01eddf1c96cd224283253fa3aaf35b33ca31c3abeac6ce6baf9687d63f91ecfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb3135f5ffcbbd8f2c44dfd964b5f04d7a324137bc775c72f16077ceea3f3f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a916715a416b5c55367ad66006e00cc94cf3d8fce0cedd22beab76ab461e9868"
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