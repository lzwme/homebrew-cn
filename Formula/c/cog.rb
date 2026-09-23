class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://cog.run/"
  url "https://ghfast.top/https://github.com/replicate/cog/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "1f9ea0139c74c403bc0a63515396247800be1a67682f4e476ced60de2adcbab7"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60b73981b5f72ed59bb30989ecdbbf7ad0378544c95e08cefa149f7a82bfc0ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1fc476195f334b0255baaaa16b369e667a6873ae283eaf6a526018fa65e24537"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9dfd5783868cda86f351390c9096bc2a9acf55765f7894740fc288a31b156c94"
    sha256 cellar: :any,                 arm64_linux:       "607c2421c1f09ad6f7c21ca649ef5a28a9ef49ebc3e7642cba3b0ced87812aa7"
    sha256 cellar: :any,                 x86_64_linux:      "dbb62518f5fb7e18e89ef8127fb2bd859d1b63c5526ca72213d06baa2e95e7f3"
  end

  depends_on "go" => :build

  conflicts_with "cocogitto", "cogapp", because: "both install `cog` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X github.com/replicate/cog/pkg/global.Version=#{version}
      -X github.com/replicate/cog/pkg/global.Commit=#{tap.user}
      -X github.com/replicate/cog/pkg/global.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cog"

    generate_completions_from_executable(bin/"cog", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cog", "init"
    assert_match "Configuration for Cog", (testpath/"cog.yaml").read

    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
  end
end