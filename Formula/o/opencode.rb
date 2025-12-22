class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.184.tgz"
  sha256 "b3406a51036bc263a41a06bd76dd48a30abee218eafcc5462ae3b6f7548a7767"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fb3a1d07ac33b570debd545c451e1aa3dbb0d622cde23ca7bd1e2e4bfae44bfb"
    sha256                               arm64_sequoia: "fb3a1d07ac33b570debd545c451e1aa3dbb0d622cde23ca7bd1e2e4bfae44bfb"
    sha256                               arm64_sonoma:  "fb3a1d07ac33b570debd545c451e1aa3dbb0d622cde23ca7bd1e2e4bfae44bfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "85aabb12bea49319818fe105f6912f65c881d30528bd1f542d4432f201d0d390"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dda8a839f54faea57a8c151ba064dba0c286300c42f4c4a1cdcc4ce0a5353620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7598bffbed4a44f778070ee85105f05eb657daf8df90b4ab8f12b0de853afc19"
  end

  depends_on "node"
  depends_on "ripgrep"

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