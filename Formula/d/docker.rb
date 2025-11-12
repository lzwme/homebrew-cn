class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.0.0",
      revision: "3d4129b9ea4fa263e57984428ad908f6a7d4b94f"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6369143f160dab7e77658709a75262d65938cede409d3ef656a0cbc90b207364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bed9ca58f3e763047b3bdbea6887c95002c0c324107e1cede86d03440d4bac27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c4ec951254da05efe5ad299175cc8eaee7a928dd8326fc8e925bc62e03448ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "95ba12e6b612baf32b20a680507534e891ce46e284c8b1177393076457ccb3d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "696219b551aaecfa9552bb9b4d1aa77c8e6c3b7e99d9fc00e99c746a79fc7a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb4321684a65320d6aed3f3d10499b7724f7f8d4865efe68e2c00e2213486cc5"
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