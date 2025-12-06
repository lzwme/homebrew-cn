class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.134.tgz"
  sha256 "a08a61d4bb765d48ef18ee8ae8197af60c82c7770e22adb8a95c9d7477ba41f9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c3f872d44c3f8b71f35ddf27bde256e20b14d0453bc92e92edafc63341e2ad62"
    sha256                               arm64_sequoia: "c3f872d44c3f8b71f35ddf27bde256e20b14d0453bc92e92edafc63341e2ad62"
    sha256                               arm64_sonoma:  "c3f872d44c3f8b71f35ddf27bde256e20b14d0453bc92e92edafc63341e2ad62"
    sha256 cellar: :any_skip_relocation, sonoma:        "72d95412a6b061563f323393cae3fdabd1155f27c2111f042363ea63b82045b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e022251644c124f2d07785c1963330132e473ac603b97a9e7e93cb215d182be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a3de7d9c51e16fc851bc08cb9169931e7ea567a45a25b9957b42419aa8c33d1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end