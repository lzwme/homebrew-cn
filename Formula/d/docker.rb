class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v29.4.2",
      revision: "055a478ea9010a19d0d4674c0d0e87ade37a4223"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]ce)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f617fd981c5deb77f6d71c8a9a53f45cc90cf55a0ab970b615c8819a103f024a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ac768b4dff74523b91075d9a315e5a4d6ac5f9c8a2f4044cd17e7017710a5ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4521a47a87d6cfc11ae25c6e176bfbaf2ad5d1480b440fb03f1a08a1670d0890"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad7a068ba0301104009b48aae5868ed6594ddbb0edcb885e635b2e18e0000292"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a8e0bda1de232de8850983a1dcd9edc82e0e85e4235d264fdcfeea756b7889a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66d7089ba63e204ad8caa042157daca930f4e0868879c5d73d59317fd8431cc1"
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

  def caveats
    on_linux do
      <<~EOS
        The daemon component is provided in a separate formula:
          brew install docker-engine
      EOS
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end