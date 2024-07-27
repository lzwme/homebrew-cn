require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.73.7.tgz"
  sha256 "576cb687e564e0814bea395804e5b443e239e8836916b6c23bb787f9d40eb315"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da83d1ed9561e36770e452ff5e84ca7a07f2a758a63714e122b29a67f67374ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edac6d725ce5ab811aa519865a4f12c462b458369947060e7c57f51e32326c0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee827791ee959660766ad63ad80600d76d12f775938df67549fb9b471832afe6"
    sha256 cellar: :any_skip_relocation, sonoma:         "00a5ac08f105e1be0056bf9c0cc64f129d915b4eef83be214aa4b8045f5be22e"
    sha256 cellar: :any_skip_relocation, ventura:        "9aa700542d8635ade03a9667cd3b276d85d68872c8cfd1926c4523cfd245f313"
    sha256 cellar: :any_skip_relocation, monterey:       "4c7100ce8fddabb542a149473eb7813bb82fd4b68a591002f574b7de34360071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f7a575292a417957b38a6e1accaf84f4e9114ce6bbfdd655ec984c96955f0c1"
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