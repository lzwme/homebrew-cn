class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https:slimtoolkit.org"
  url "https:github.comslimtoolkitslimarchiverefstags1.40.10.tar.gz"
  sha256 "56b80f166986be703b8c2bd680e63def30bd793236ae5b6d78a3aeae3ce26735"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32a7a90bb444252841afd7f515bfb2ea3cc9ab250c8973978aa89373536c7898"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3c4a62e822658444ea5f49db5fae8e08f7edd8ee1e0a66d47eabce9a9884c59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e21957389775def9d2ea022429f0f79f75d3fb9e39b0b75609b5b821c82f3ca7"
    sha256 cellar: :any_skip_relocation, sonoma:         "b17e266163c8da48afe35e0a63f399e90ce9e148c76f050c3f478df35289f4d3"
    sha256 cellar: :any_skip_relocation, ventura:        "23c9b8a1c2e89b83a35d5473bcb6af674dee347e7db10062e1dc5f1d38df7e40"
    sha256 cellar: :any_skip_relocation, monterey:       "91e597b186b0dacb979e9038fef45fe88a13904a195b6c82e7e28f97ef4deb52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e43f4a008a91102a12f3af12a2a1a6bbb275ce0a94ae2cef3641c4a147e5d5c"
  end

  depends_on "go" => :build

  skip_clean "binslim-sensor"

  def install
    system "go", "generate", ".pkgappbom"
    ldflags = "-s -w -X github.comslimtoolkitslimpkgversion.appVersionTag=#{version}"
    system "go", "build",
                 *std_go_args(output: bin"slim", ldflags: ldflags),
                 ".cmdslim"

    # slim-sensor is a Linux binary that is used within Docker
    # containers rather than directly on the macOS host.
    ENV["GOOS"] = "linux"
    system "go", "build",
                 *std_go_args(output: bin"slim-sensor", ldflags: ldflags),
                 ".cmdslim-sensor"
    (bin"slim-sensor").chmod 0555
  end

  test do
    assert_match version.to_s, shell_output("#{bin}slim --version")
    system "test", "-x", bin"slim-sensor"

    (testpath"Dockerfile").write <<~EOS
      FROM alpine
      RUN apk add --no-cache curl
    EOS

    output = shell_output("#{bin}slim lint #{testpath}Dockerfile")
    assert_match "Missing .dockerignore", output
    assert_match "Stage from latest tag", output
  end
end