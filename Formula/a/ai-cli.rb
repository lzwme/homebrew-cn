class AiCli < Formula
  desc "Generate images, video, audio, and text from the terminal"
  homepage "https://ai-cli.dev"
  url "https://registry.npmjs.org/ai-cli/-/ai-cli-0.5.1.tgz"
  sha256 "07825c23811a1649dd15135a1471339b02ede11d3d98d9e79c0ce77bc1a5773d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e5401cc42e66f4260f61ecbc648468d136714a7569a4bde21628e9000cc6f52b"
    sha256 cellar: :any, arm64_tahoe:       "e5401cc42e66f4260f61ecbc648468d136714a7569a4bde21628e9000cc6f52b"
    sha256 cellar: :any, arm64_sequoia:     "e5401cc42e66f4260f61ecbc648468d136714a7569a4bde21628e9000cc6f52b"
    sha256 cellar: :any, arm64_linux:       "d19d53b6050e2229a1e8dbe03eeaecf1377a4410aeb73f9b12a479423a1e7038"
    sha256 cellar: :any, x86_64_linux:      "c817c97b4f15c3f07ceafd34cdc848f33ee89bf523c3db26ee4e289582c6c729"
  end

  depends_on "node"

  deny_network_access! [:postinstall, :test]

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/ai text --image #{testpath/"missing.png"} describe 2>&1", 1)
    assert_match "could not read reference image", output
  end
end