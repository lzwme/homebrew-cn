require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.61.0.tgz"
  sha256 "68de168b806dae240315ddf26f97342994d52285910634434deff8f2a6228e9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bd42c7928a8b88354b3a93a637dd574aa76dae6a9fab22d6e3a15c932c03cd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "499dc9ca214df42773bce11cbac9214382a288ab561af2017c4e81a1b708978d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca6ca68b110b78eb1264e08c28f82ba099ac8dd82f3a8cdafb293f3fa0674730"
    sha256 cellar: :any_skip_relocation, sonoma:         "eef0796c41bf3dc9195124f922f7814db8820979bacfe85d8bb944683d5eca42"
    sha256 cellar: :any_skip_relocation, ventura:        "a5e346206d23c4033270f66d6d165b1999620d6fce73e7828dd9a317c0f9b2dd"
    sha256 cellar: :any_skip_relocation, monterey:       "8670b7a893a376f470d4d9d821a26bdd3e3e06eceb65abaa709ae827852d01bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aee730ccd0fa05160023a99f220050ea57ab488602185f26844645cae6d12a00"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"promptfoo", "init"
    assert_predicate testpath/".promptfoo", :exist?
    assert_match "description: 'My first eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end