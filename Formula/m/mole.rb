class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.41.0.tar.gz"
  sha256 "4331b3c7bb52187891bdb050a4c081fd02c7556d454dcfa847d78f07af205efc"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1915bbd87df28627cc3607ccb7c9c25d0981d80f7a4dc1f381f7fbbdc75aa99d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "538ba7dbd28d373ed1e4bb865244ab27a3d1af7068c880a8c955f8a2d080a50b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae87683b0b75b464ae5105b8ad48b9aaffba305817eb170f3d21389ff5b436d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "26883d5fdd9ca351aa7ddb21ef6d9699cee136ad4656301260a377c8ea65679e"
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