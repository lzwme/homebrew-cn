class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-7.3.0.tgz"
  sha256 "c64337942bc1d37044628ccb2c080a175553f1ca12c8be05865ac96c383a604e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91a292266e5bddc172628492f0686030ed9da96c00a3524660b5d8437d2c747d"
    sha256 cellar: :any,                 arm64_sequoia: "54cc8608bb51505feaa344faf07b77df6d420cb2947500217576a0a2dab847bf"
    sha256 cellar: :any,                 arm64_sonoma:  "54cc8608bb51505feaa344faf07b77df6d420cb2947500217576a0a2dab847bf"
    sha256 cellar: :any,                 sonoma:        "ba3bb90a066eda831a01b0d1bb0dbafbc0c45b33ac63a8a1acfcee880e9f34c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e170f7c676413a49d7b52633cf662d8f8b2cd0d55dd0dee390c41bffbae94a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91da9a9019526594b614f11d698d8a0223654b79da7539ad14228a2cdfe201d1"
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