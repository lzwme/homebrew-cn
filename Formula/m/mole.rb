class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.39.0.tar.gz"
  sha256 "83e147f43a2175b4db2762411e38798364c13e9bd5f238688518662d3003ff72"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39e8927766c9483794730e54871d733c39abee78b4d1aac3b82f42e035aa03ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30355be11dd3a5862e794b7b0f7085f20e3768556d9f186a4a957c185120edc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfc6a1ce20142ad1f85fced6863f0db1db075367c33acfd2f818ee65b999d290"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c78b29c94e259a730e43152f954b778138e9320c93990a0f97a4018dc993cb1"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
    %w[analyze status].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: buildpath/"bin/#{cmd}-go"), "./cmd/#{cmd}"
    end

    inreplace "mole", 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"',
                      "SCRIPT_DIR='#{libexec}'"

    libexec.install "bin", "lib"
    bin.install "mole"
    bin.install_symlink bin/"mole" => "mo"
    generate_completions_from_executable(bin/"mole", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end