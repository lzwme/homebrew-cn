class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.14.4.tar.gz"
  sha256 "07390cc65555fc2f0b2d30a3816ef9a3f5867cb1b35e2b7ab09377e9cac87344"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3877839a6a756004eff2d1688bfeaed632c94ee26e527edf55c9688bec2d7e42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60d04771bb79b79fa1840469cc9cdb11a390b333ca3b2346ae67cc21814624a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d45f48bd0d6c7de32b06c49c920b4fc105ba37075066d2713cc4e43031113c2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee2f8fe1301f727f8f8b941cca910d38a2433d61bdc7cb3ff6579c4a6b705d54"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mole --version")
    output = shell_output("#{bin}/mole clean --dry-run 2>&1")
    assert_match "Dry run complete - no changes made", output
  end
end