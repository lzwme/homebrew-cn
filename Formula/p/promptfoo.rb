require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.72.1.tgz"
  sha256 "ee4b334cd75737f1c9b6f025de1a712dff451926cde7c27721e55d7fae21885f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fe747bab01fee138c472f69be46a1f8d36160d80cc54311ce9f7101751a6852"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5d7a2e05ed880f40324206f8cee8a30c714966333bf1096bd8b3ea8aea54f7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebbeffd37978815552a361cb911131439151289d74b0c0c07011cd4125e6b0ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc37891274c909341a9bcf86091cda38c4ccf44cde48f19e4a6d3693db99b406"
    sha256 cellar: :any_skip_relocation, ventura:        "85c8726655823dcf27f4cdfaf9c6d4d5d0feb40044fcec82cbda26ae7c42e37f"
    sha256 cellar: :any_skip_relocation, monterey:       "6a684d867f56a6be152a6a410474fddf00e8385f639508c9ff564e783c3ceaba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08989955e0c07313a8a9974dab9003bd3976c817678ac14c41e7d384a007f258"
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