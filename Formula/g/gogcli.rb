class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/openclaw/gogcli/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "888ec3036e04e9b59e806b29bb0af95562d55f059008a78748d637ade9141538"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9e7b95f620444cea7b6016d8307f013591bddb8a3d6360cc927ae2164245066"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c245174952ed493182509ea81f6a9d1f84a624c1b332febe3a6ce822f6690b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d5a3585cd7a038919ebe983dcadfb0087775cc5bde6dc762eee4af99db5502b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4899f347e24271720a4651a6fe1c4947ce212966fb580b64be564f2db75e7cd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "35608b1fdff4ee09eefbf144d17938cbe0226badb5b6afe9761bb093f39cef03"
    sha256 cellar: :any,                 x86_64_linux:      "9644cbb3f6776974e21edc1b75678a9290971cf916ceaed043972401bca37b5c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end