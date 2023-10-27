class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.7",
      revision: "afdd53b4e341be38d2056a42113b938559bb1d94"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "530c4a90be8502490b73898b8670b1f800b01b4b4654f9d27eed3f1aef988cdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41eb03dd109014531e2f83b64e3ad38c3781ac6f64a9834d4a67c987a17ff58b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e255b7d307c93b8f07f02cc9537c856bdf952683b20564167f5a3b5c6c892614"
    sha256 cellar: :any_skip_relocation, sonoma:         "195afe83829919696d5b27aad360d534c75386ad87bf6052a9f989860c008e7a"
    sha256 cellar: :any_skip_relocation, ventura:        "11c6bff3e03a33a78ca2a9e13a6d12b18aa09f17568b2791fa8f0ccd613833c2"
    sha256 cellar: :any_skip_relocation, monterey:       "7efbaf5ad18ef88b39e1a639c7b8b937a47005cc74ebfd506bb71fdc16bd9b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d3aca34f08b146a03e74cdb4b3b9418d3d89b47f965d048e52798022473a68"
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