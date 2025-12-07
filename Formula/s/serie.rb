class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https://github.com/lusingander/serie"
  url "https://ghfast.top/https://github.com/lusingander/serie/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "6383e79eb1005f83fa69059973bf75ae4a7b0f2d0900b1642d5a23805695b27a"
  license "MIT"
  head "https://github.com/lusingander/serie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52c9d395f0ba6e76d0c41b963f984116c4b51e3a5df3bfb3f9d62ef6e8ca2aa2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bbff4c6d1a542f1c9623d19487fff95de8c64424d789cf9d47b51eb99b64528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "493d532a1f5c7899f7dbefebdf0b7473c668fa7716879457f542bf2a752032c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a7c80dc732158c5f6cf69d77ce7d8a6a0f6fa14b3e08748c916e458ca12d3dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "955ab22d7fd186ffe124cecfd3b0ca468ab8768fcb6f1df72e966bc93c56d831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57d88589dcd964a3f0dd782b45eb252c901826b44db8a4341783220fad36ed16"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serie --version")

    # Fails in Linux CI with "failed to initialize terminal: ... message: \"No such device or address\" }"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"serie", [:out, :err] => output_log.to_s
      sleep 1
      sleep 2 if OS.mac? && Hardware::CPU.intel?
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end