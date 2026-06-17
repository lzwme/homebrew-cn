class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.43.1.tar.gz"
  sha256 "352b2ca03c07d938bf2eb4a8d592ea92e25f6456499f7430d7c87102f3c83f13"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e90d201a6ceddc06060dd1a1357c83ac51cf5bd1ff0a47042499d03c8b76241"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd1cbf86db80a90a43aeefa8a2cfb75b4a6ea3c3d579b5295fb6f304ebf6577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e78ff0e6a7c9ba675bfb08f47f6a80d0004714194e585a36d90ae467feb9780b"
    sha256 cellar: :any_skip_relocation, sonoma:        "055db71dd86999be5351a2ee36fda90a429461814c823b9aff5bb21b40a47780"
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