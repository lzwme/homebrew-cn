class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://ghfast.top/https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "fa5af449bc8ff1fa9fca8f7cc77e62a20bf9660f4e18e502a904b49a98afb50b"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dbd96683bf2f665e8c21280320543fa5a0f14dabdf384bbd658378676011094"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dbd96683bf2f665e8c21280320543fa5a0f14dabdf384bbd658378676011094"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dbd96683bf2f665e8c21280320543fa5a0f14dabdf384bbd658378676011094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86c0f4ed4b78bcf4085287db4b5607cef14d5869f3887756096186aac96be3dd"
    sha256 cellar: :any,                 x86_64_linux:  "1431364feb772f749db650210f1c35c56e4d6ae2cd0e9c3444dc38a1ce3e265a"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end