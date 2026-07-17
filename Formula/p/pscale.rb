class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.303.0.tar.gz"
  sha256 "0ac4b677562f01a784868a011afba62098db7e12cb702f276370dbf6d9a20d23"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad0388d93a267e22f25114a687b1f22e524de38db470c01e49c61b9435e36382"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fcf6efe60a6ab030d8957c8a2c2687e281a3c1edf9196aba515761ea36c228d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20c719c1b3a68e65d8c340a1cf53d425159f75895bd240e7b5e4f57902781722"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a3328110886df5489f17fdd77301704c5bef2cca3d7fde17c33facf074d81d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0152b8d7a768593edc463f0acac6057701ecf9492c5fcb846a7a01a505b589e4"
    sha256 cellar: :any,                 x86_64_linux:  "7875f0959b23ec8e1241177c86c9f406d4abb4dcdbe94d896d0705f7ca32090a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end