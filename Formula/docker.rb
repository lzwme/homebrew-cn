class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.4",
      revision: "3713ee1eea0447bcfe27378ad247c7e245406f04"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "993a7739c3097bad48f5020581d92d6d84bede595d920d601da96ed9c8d6d6a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "993a7739c3097bad48f5020581d92d6d84bede595d920d601da96ed9c8d6d6a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "993a7739c3097bad48f5020581d92d6d84bede595d920d601da96ed9c8d6d6a6"
    sha256 cellar: :any_skip_relocation, ventura:        "134bb49a68c785945d72c7d5c13b702de6071fe1e5adf453995f80436037fb3d"
    sha256 cellar: :any_skip_relocation, monterey:       "134bb49a68c785945d72c7d5c13b702de6071fe1e5adf453995f80436037fb3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "134bb49a68c785945d72c7d5c13b702de6071fe1e5adf453995f80436037fb3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67b68c19abd8ea62e8c26a9dd9f43296b6160b653097fcc2edd633bab1a12ce1"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "docker-completion"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"
    ldflags = ["-X \"github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}\"",
               "-X github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
               "-X github.com/docker/cli/cli/version.Version=#{version}",
               "-X \"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""]

    system "go", "build", *std_go_args(ldflags: ldflags), "github.com/docker/cli/cmd/docker"

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