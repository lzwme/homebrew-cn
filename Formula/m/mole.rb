class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.40.0.tar.gz"
  sha256 "553a61e3aa73a1709359929319bf557f3f59e486c4ff61bfe937b62360ff4d5c"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db8af6b3b2aa27d9292a53c82dbf7601cc2e85d5ed5902d0368791182e4b7b87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47520e164d1074fd9c2f253d09ec30bafbdf45c42a21dee3a1454163f1f3bedc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67e5f8c3d4ef0f8364c7bbb2f2ff34d6239e829a98c4149f65ecf3bb00a0f571"
    sha256 cellar: :any_skip_relocation, sonoma:        "d945f95fc96a796c75dd0b66c916f535bb8ffdfd91cd73005be7e883a7fe7aa4"
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