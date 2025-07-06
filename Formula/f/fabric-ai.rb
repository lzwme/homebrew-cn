class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.231.tar.gz"
  sha256 "ec3e3a1cbd429a590e2090b6cd760cea2ba9558cdf9067b495c0beaa499869c6"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ad30d568ae4da1ffa8503e0e62cac4260876abf98e11cc9d0a695cdfec97572"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ad30d568ae4da1ffa8503e0e62cac4260876abf98e11cc9d0a695cdfec97572"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ad30d568ae4da1ffa8503e0e62cac4260876abf98e11cc9d0a695cdfec97572"
    sha256 cellar: :any_skip_relocation, sonoma:        "8854e92dade18a844231d08d821d5ecf46de54e3aec7ff8a6bbef1964129dde9"
    sha256 cellar: :any_skip_relocation, ventura:       "8854e92dade18a844231d08d821d5ecf46de54e3aec7ff8a6bbef1964129dde9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d90155f28f9637bafc0f16a407b41a8af4add0125cae81fbccf931264bd9dcf8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end