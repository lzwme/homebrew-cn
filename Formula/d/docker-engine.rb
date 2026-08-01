class DockerEngine < Formula
  desc "Pack, ship and run any application as a lightweight container (Daemon)"
  homepage "https://www.docker.com/"
  url "https://github.com/moby/moby.git",
      tag:      "docker-v29.7.1",
      revision: "c5b8ce9274b5c00cb1f8287c8e258edc1f01176d"
  license "Apache-2.0"
  head "https://github.com/moby/moby.git", branch: "master"

  livecheck do
    url :stable
    regex(/^docker-v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "af4857d8357b7f80a69ff6777e566743307db8b6c7397df7b1a5c2a6da2df579"
    sha256 cellar: :any,                 x86_64_linux: "546ba89d82f93ac702b2b22a05d13ca9a835d06a81906c54c3ee225cb70ed132"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build
  depends_on "pkgconf" => :build
  depends_on "containerd"
  depends_on :linux
  depends_on "nftables"
  depends_on "runc"
  depends_on "tini"

  def install
    ldflags = %W[
      -X github.com/moby/moby/v2/dockerversion.BuildTime=#{time.iso8601}
      -X github.com/moby/moby/v2/dockerversion.GitCommit=#{Utils.git_short_head}
      -X github.com/moby/moby/v2/dockerversion.Version=#{version}
      -X "github.com/moby/moby/v2/dockerversion.PlatformName=Docker Engine - Community"
    ]

    system "go", "build", *std_go_args(output: bin/"dockerd", ldflags:),
      "github.com/moby/moby/v2/cmd/dockerd"
    system "go", "build", *std_go_args(output: bin/"docker-proxy", ldflags:),
      "github.com/moby/moby/v2/cmd/docker-proxy"
    bin.install "contrib/dockerd-rootless.sh"
    bin.install "contrib/dockerd-rootless-setuptool.sh"

    man8.mkpath
    system "go-md2man", "-in=man/dockerd.8.md", "-out=#{man8}/dockerd.8"
  end

  def caveats
    <<~EOS
      To run dockerd as the current user, execute the following commands:
        brew install rootlesskit slirp4netns
        dockerd-rootless-setuptool.sh install

      NOTE: As the lifecycle of containerd is managed by dockerd,
            do NOT run `containerd-rootless-setuptool.sh install`
            before `dockerd-rootless-setuptool.sh install`.

      To run dockerd as the root user, use `brew services` with `sudo --preserve-env=HOME`.
    EOS
  end

  service do
    run opt_bin/"dockerd"
    # See the caveats for rootless mode
    require_root true
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/dockerd --version")
    assert_match "dockerd needs to be started with root privileges",
      shell_output("#{bin}/dockerd 2>&1", 1)
  end
end