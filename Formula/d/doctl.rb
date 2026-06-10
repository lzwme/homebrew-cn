class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.161.0.tar.gz"
  sha256 "81403ea9639b1899bc0179dc4e817974a3d49d6378907d406ea917becc03c459"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acb4663aea58f674b93985cc85a4aec27b69f068ffe2feb25e2219b65b0f32c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acb4663aea58f674b93985cc85a4aec27b69f068ffe2feb25e2219b65b0f32c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acb4663aea58f674b93985cc85a4aec27b69f068ffe2feb25e2219b65b0f32c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9ea8fb381f657dd03b30776e47feec9693cb40c9f4d1192b64792ddb8880701"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "584302c08c7265ccf995dd2dc7d0985b37d4f95656c5b82c834a6bad6a99d0d0"
    sha256 cellar: :any,                 x86_64_linux:  "856536f7605d2aafbd8c684d9aa2edf56fd7437d8a4fd429864225dbc9887f46"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end