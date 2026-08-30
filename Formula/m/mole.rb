class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.53.0.tar.gz"
  sha256 "35c812d5298a08c672062ac4e1d5a523876144ff0708f9c5c77385d52faccc77"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41c78feb32e5cb4ae4d17bfa5836c1473defc1b90df29972f0825ec3c3e7efa6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c09f4a217e0c6680eb87e3e62de445f6a96c449a88d2633d0fdef4a4bf70bd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1b8ebfbfb2a9f8109117513f7c22f5e407e57e64a67ec961ed2ee087270aea2"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
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