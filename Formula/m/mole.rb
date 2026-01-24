class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.23.2.tar.gz"
  sha256 "c164ef840edd654786f71ef7d7510c4edbdac5120ddcee1b5e152fa5a7e81544"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "021b96146919e026fdcfc1c54110ccedbf7b41fa6760afb9df47d10ac1a7d79c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ea7ef3d07ad53d73e09c06356e95211d1f421da3e289299e383b19e38200016"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "752ddc529a78ec69c6ca91b21c2ec8cd952b13aae64d58e3ba8649e4c27b73d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "94b025bfae4190475402f150712b5d09b9356b618d9f6e2ef8d0323937332bb3"
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