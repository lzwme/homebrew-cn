class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.25.0.tar.gz"
  sha256 "df22d7f2670b5331dc6c5d3ecef4c34adb7e3d3b925a36501df755835388cda4"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "642f90b5c85b9823062280e7b298a9aaac696d28522d81c163b1d68ada13c6f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "762b5191797ac250734fc5439554a87e4ca05d5ae85305c4ce894471dd31a145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a500e06631f97e43913a6dc6dcce9f26429d0ab9d4003f458dc2965076b6d36f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6692e78924ba74607eec9455af42ba5bb13274fddf99bc6b2f2cd19342ba0e6d"
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