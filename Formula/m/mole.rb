class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.14.3.tar.gz"
  sha256 "3b4f6c3aaf5476a43b4e8b42fe57a182ce99c5d300112e7665d9afb7fa5a0d4a"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e8d66c0d767a642a3cbd8a81854c6cfedfaa8c99013a17939474b57fb54954c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6259f2cab9d8aff70d029417de208e87e2a81ffa0fca3194a6b2cb3345395899"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b843645507f5c4d55798fb175c59fcd997241d214239d8d8477ab29954ee98c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ce564d0b53acd4992bdadfa826fcdfbb7750f90fdde03fcb0c4e33a36226896"
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