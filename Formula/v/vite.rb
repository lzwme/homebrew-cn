class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-8.0.14.tgz"
  sha256 "b015e53dee1afe0dc940c110b4052e84b1debe14944bcf30e574d8c44c5b21e3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d207e5bc7c93e76f353bc3ebecaf58bcdb72bbe1eebc08b08f0f13c58274bd63"
    sha256 cellar: :any,                 arm64_sequoia: "57b6550aacef11bffea4c3e6f675122e3fc1f02349f21eac625cd7df360eb8cf"
    sha256 cellar: :any,                 arm64_sonoma:  "57b6550aacef11bffea4c3e6f675122e3fc1f02349f21eac625cd7df360eb8cf"
    sha256 cellar: :any,                 sonoma:        "7a7af1f91db61e8146bc0e052ea61f066762fdd88aa45a72924dec176fc4dedb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9659a0e05ecab916b5214593160a257b1ad85c834b803a2688448854a3d58d98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99c56981a9bed96c490d05fe247d61836eb87caeeabdab8c973d7e22df57793c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/vite/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/vite optimize --force")
    assert_match "Forced re-optimization of dependencies", output

    output = shell_output("#{bin}/vite optimize")
    assert_match "Hash is consistent. Skipping.", output

    assert_match version.to_s, shell_output("#{bin}/vite --version")
  end
end