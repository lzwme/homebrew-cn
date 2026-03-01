class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.28.1.tar.gz"
  sha256 "21a753d3cbd79a4e9804be3f7e5ab039d6496c4433c77fac4e8412c0015b5c83"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ae28ad53738ff0c35f21222fc6452749e5e51a13635b219112e29ee412f4724"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36a34759a6cd966e703d92cdacd518aa6c1d56922a9bb51665cb13408484ab99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0783e4abb2468b9933933dbd6d33c7f000d538af81267e935c8bb545bfb4a8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "88833e00f2c7be9ade2c9b49dd25a368e44db4c307cc60653fb0a71c0be1ee49"
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