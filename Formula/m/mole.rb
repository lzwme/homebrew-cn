class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.48.1.tar.gz"
  sha256 "374dcdc981d0581cdf5007311fb5bf4cfe326ad5fe2a7735ffc44a3f7c91b049"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43fed01b5e617278a995d8a0591c3bd71eddd001b32dba6ab04ca4a8ffe966b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5afd7241e2ed12768021e693c13b15a315113f1596c736508ed89ea1b8acbd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a88ab801d82ef8f060c78f30ece733e49a58a52ee96513e05da45ed34594966"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffd81f93809e8d083179341030ca622629e2705a63247f6d5150b7ca64df1454"
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