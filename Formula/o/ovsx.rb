class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-0.10.4.tgz"
  sha256 "45a08bdd15d3ab8b91697831ae57ade1771c659420e10dc8c3357f3f04a3e35e"
  license "EPL-2.0"

  bottle do
    sha256                               arm64_sequoia: "a633010cca2d425de7134b9f8c7eaced43aada13ab1d11c243db08054d904a9a"
    sha256                               arm64_sonoma:  "c50710959d1ad0db551e9cdf6bf281fb495ff6c3a2fc30dcd046f263fac9f5f8"
    sha256                               arm64_ventura: "2e532477591fb64f9e94f2f77f018d3951296b2d1ba26e9e4507af3bb001f335"
    sha256                               sonoma:        "d7127cb21458be14c859a6942fe6830701c7a070234c942701a9b008fef7aa43"
    sha256                               ventura:       "f2f6515837a2a78b950c810382b5bb00937d43e6d78125acc91b4fce8e673e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15fecb2efcaf44f7d51c7eb3913468c52c793bc3f93b7264ea1715b370b4b258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bf7afe01906b628b1fbe5d894d1c05c8c3823581bf3e21a99857f84527b25dd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output(bin/"ovsx verify-pat 2>&1", 1)
    assert_match "Unable to read the namespace's name", error
  end
end