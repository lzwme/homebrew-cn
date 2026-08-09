class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://mole.fit"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.50.0.tar.gz"
  sha256 "08e4575ae936bb79a5554f589bb84a30c6d6eb89b6f5c74ae0022bae5425dc39"
  license "GPL-3.0-or-later"
  head "https://github.com/tw93/Mole.git", branch: "main"

  # There exists a version like `vx.y.z-windows`
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41162c2b22b8c8105532633c9bb6484a4562330cf8a4a26c9f448ff709541365"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71b1eb603b3665eddc8eeb2d708623c84a687293e9ae2c3d222a2064e949388b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2cad6ae21a75528683a7eabf9e6e01e1fc3886223598014ec6cb002202bc9c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "57b61bead2b0963f5b50f64190d63e6c4bfa23973cf9011782aa04ff4cbf2129"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    # Remove prebuilt binaries
    buildpath.glob("bin/*-go").map(&:unlink)
    ldflags = "-X main.Version=#{version} -X main.BuildTime=#{time.iso8601}"
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