class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.18.0.tar.gz"
  sha256 "c1c5cfb3b6d27deeca485f6a04a8e52297d53606c82bd6e2837f3eb30ab9d2a8"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "751052d81ac57c58dec8a99d001fad4ebe870bcae2da6dbf7d41863449f9fa07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eea39f28920688775317f72aaae8b2cc90d24d1ffed0aad2c4d12ae5ccf24cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e24c0aaf6ed586fb0e6d1e7e483ed7b7313e8fa5a3142128eb02e6b3f17f2292"
    sha256 cellar: :any_skip_relocation, sonoma:        "460b3ee491ee59d6b424603086e9e5e25aca3f3b45e7c1ca65097fb0f744d4a8"
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