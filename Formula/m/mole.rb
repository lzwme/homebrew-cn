class Mole < Formula
  desc "Deep clean and optimize your Mac"
  homepage "https://github.com/tw93/Mole"
  url "https://ghfast.top/https://github.com/tw93/Mole/archive/refs/tags/V1.18.0.tar.gz"
  sha256 "c1c5cfb3b6d27deeca485f6a04a8e52297d53606c82bd6e2837f3eb30ab9d2a8"
  license "MIT"
  head "https://github.com/tw93/Mole.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e5c74d2c6345cfdeef8bdceb1bcbb450c808c5eb61d01dfabe9311d18213edb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e087f1c94d96b223f93b8753075f570121461bf3fa7e7decfea804dfcecc1bd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eba363e730a48e644b6f7e4cc1aef0b94298bcca5103394e6962f58d92368684"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0b0ea267781960df9abe30ec7a5ce539062d2cf82be485cbc270c91a60bfedd"
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