class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.36.2.tar.gz"
  sha256 "06551fae6a014ecf799cf700da5e420d0a55b151f757f6ad89aa0a70aa4abd98"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5d065b5cabcd2af3f2b7975ed4983c19838e81c0e68ae6ddcda7744a2f3cdbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43731bd38812fa3e2cc11b98444dd20cd4cf07689329044853c650ac170a5840"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b49c0cca343b79d20c5a3ff29019c05766ec97f3685542243bb7af4abf13e8e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "14ea8d9ba29ce6bf1e491021cc559ce975e75484021f494a1da68ed09bb81cce"
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