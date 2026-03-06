class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.29.0.tar.gz"
  sha256 "03623ce5336b9b19a0c35908b9e9410df734c20f06ec8821e2af7a1c4283f312"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faa30f711b63b31730ac5b5de301e4b202d782f91589eaa9d55dbc5543f7ace8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2acebb50d85cb7c5e58536e2748e034030f4fe0fef59b4f46f0c284790e8ca82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ab117bc50972f7e8e197c49b56846a9cdef80d12bec889263c59fed0f4cbfbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "36d701ea075ad81819c48b00da160b8879ce6591daeac8260b232f4ef1874433"
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