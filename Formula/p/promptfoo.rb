require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.73.8.tgz"
  sha256 "450faa54e212f969906f0fa14dee56d9a999ffe2173bf8f680fa4aa927c84aac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9cd1c753be3a7a9b3a098391b236b8e436c225477e5ab8fdb3896c476bf5e7d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e1710276eed19729e8aca01730578c628582b50edcb4baef2fcc3094ecb68c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4992c4f5ff402a9b522bb02704ca2d5a54fddb0dcc84665dd38a0ee8823a0c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "03e165322a6541b85d604b73d2a687cb17c992f09f76738b5bd850b0a4bed365"
    sha256 cellar: :any_skip_relocation, ventura:        "206a177539304853ff84773c010f4744a0f2ac40df0edf387d6d4bd55222d585"
    sha256 cellar: :any_skip_relocation, monterey:       "f23eb741c8f60f256971c2eb716b7bf24bade07bf21871ef7468a37be7b3cb92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d62da216295cf0082374548488c1668500ce0980d21d2bba2d7078b3d71a979"
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