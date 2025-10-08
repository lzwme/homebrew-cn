class MultiGitter < Formula
  desc "Update multiple repositories in with one command"
  homepage "https://github.com/lindell/multi-gitter"
  url "https://ghfast.top/https://github.com/lindell/multi-gitter/archive/refs/tags/v0.59.0.tar.gz"
  sha256 "826735bfa6229b209274932dbbd2bd9b58cdfbe8dc431c339777d16b2c87d05f"
  license "Apache-2.0"
  head "https://github.com/lindell/multi-gitter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40bc83b5d09aecafa6ab181a4ae62f42487c31bc493bac0aa2c8925679b73463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40bc83b5d09aecafa6ab181a4ae62f42487c31bc493bac0aa2c8925679b73463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40bc83b5d09aecafa6ab181a4ae62f42487c31bc493bac0aa2c8925679b73463"
    sha256 cellar: :any_skip_relocation, sonoma:        "734bd09f1e9fdef40bf0c92d92438c9e5c9ca5bab90d26b76b224af8cce139ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f46af15442afe65936da059718b4f6e4550a370df6b0ad719ebd75f6e2d4c7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf222359051b5c76ddd254e7548ce2ab0db897582dff10c0a236920c1b34502"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"multi-gitter", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-gitter version")

    output = shell_output("#{bin}/multi-gitter status 2>&1", 1)
    assert_match "Error: no organization, user, repo, repo-search or code-search set", output
  end
end