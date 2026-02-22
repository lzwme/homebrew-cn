class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.27.0.tar.gz"
  sha256 "63e5b8de0ebc4ed8de65b8cc03f68d300064da8a9d458f68a8e289d0485dfeab"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "296b5da52d8fd13dffcbdb362bde755190b0c1cc85d56526d789d5cd0970f638"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d28ff9754130c14f47aff8d2efd3c984490a9aa72a8061028ebf0797784e4b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3fe2e81abce40f3771bc196a2a077bd8297a6cc026e161a513ac34540f2ff2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "111514b4ee4d35c2f588d46b2e7607c0df987b95d814e1d7c1e1250b3e88d9bc"
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