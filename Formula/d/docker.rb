class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.0.4",
      revision: "3247a5aae3791c8306f5b2e215c314267c31c570"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "443539e72ce5e71e4b4d417d1419d6a8eb309fa7c8d474f80c1137da3f99bf2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5c1184d6b12615661bab920ac1741af79a630cbc582b5230c8fda3794ed1da2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46b7cf7a23ae678f62ea37e4176fe65fc21eeb782a1a0c74c935e7e0ec0c98b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "c749d42999ce4e612e6886c662f2df2f566b15f0f895b14fd5352a882d5b788b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "672df561ca67a93042acf45269b624ba626ccc8f8eb51f83f4f04a9f044915ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63444025adf2b90c22a7ec1aa04d1deb7d1365c7bc231c2e79e431d48467f153"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = %W[
      -s -w
      -X github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}
      -X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}
      -X github.com/docker/cli/cli/version.Version=#{version}
      -X "github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community"
    ]

    system "go", "build", *std_go_args(ldflags:), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end