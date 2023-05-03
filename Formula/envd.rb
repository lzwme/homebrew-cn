class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://ghproxy.com/https://github.com/tensorchord/envd/archive/v0.3.20.tar.gz"
  sha256 "bd13f0a644bf346afbb01758372d00c240d07f12a8d8875792b6693d8711e1c1"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dc7e9e564853ab54e35b067d067d516823c77e5657ba62c44003ad4b0d35303"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35675f70c59dd6e2b183dcaff547736817b36467500f0c1a2e09eb0b918572e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aacdb3fecdfea85c440fdd9a22ff999f22cf676b4b1b8e813f050db3c2b5f1b"
    sha256 cellar: :any_skip_relocation, ventura:        "f58d374cf64bedefd45266315c15ddf428a35a3d3bcca06684be5d014976b9b1"
    sha256 cellar: :any_skip_relocation, monterey:       "9d227d610d41706b6dbe82f5e26d371e5a386eccc36539f08eca96c78dccdca6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5027dc5ece99fa287f993a3d470346eb22cdc243b9f7d82d4213e2efc11cd76c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e430063c1ccf982f88de894ab72a58759309992ded0db0421324abf5f26788d6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{version}-#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "error: Cannot connect to the Docker daemon"
    else
      "error: permission denied"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end