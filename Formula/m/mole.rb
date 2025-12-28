class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.14.7.tar.gz"
  sha256 "8f5b196f518227077298c72fc5ea7259badca3047e791d57e0dac0dca0dc5b66"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1b40abe11364768b15a4d1954c5e48df17ffa000b3197f7b8ae3621e52013b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "467cc70e45557e899afa15afa758c17ffd6a01fb3b5c94eb498a12268438e086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5643f0e2d1c60dd7b1e53831a5c4d2d6e6e2f598d3394e0c7de8cdae1a4b3133"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fabfbbca01eacaa8582f637e159d8a3206e85f37010f96ab19896b0bd86897e"
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