class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://slimtoolkit.org/"
  url "https://ghproxy.com/https://github.com/slimtoolkit/slim/archive/refs/tags/1.40.6.tar.gz"
  sha256 "f7263ce640a60b2c88573f068ac1c9402c3c9025d186fdd556968b3069bbbf90"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26dfbcfb3ee2bfba1975b9f2ae159f8170b136b8553af2f8524ca14ee161e89e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af1e267d0e89da9961762f8170e6381bea3d450da2db081ccf785d655af83004"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14a4d5ef47ff4fea0abd4a984f3f6006a318126c21119b2649bbce71ad49d27c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba0632e380037c237e56ff29ecb66e7321316d1ecad4cc6fd4492d46891025e8"
    sha256 cellar: :any_skip_relocation, ventura:        "85f821c2ad9e1b2e71159bd506444503cb0cb6ff5cfff985d0c8a090a4c65d5b"
    sha256 cellar: :any_skip_relocation, monterey:       "5940a1ada768664fba2f68f5e46e952ed190ddd6fed07cd117426bdac3de8b13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc8f1eec401329e8cebe0407f0627d15c78927cbc3f3bc30b10a894799091c81"
  end

  depends_on "go" => :build

  skip_clean "bin/slim-sensor"

  def install
    system "go", "generate", "./pkg/appbom"
    ldflags = "-s -w -X github.com/docker-slim/docker-slim/pkg/version.appVersionTag=#{version}"
    system "go", "build",
                 *std_go_args(output: bin/"slim", ldflags: ldflags),
                 "./cmd/slim"

    # slim-sensor is a Linux binary that is used within Docker
    # containers rather than directly on the macOS host.
    ENV["GOOS"] = "linux"
    system "go", "build",
                 *std_go_args(output: bin/"slim-sensor", ldflags: ldflags),
                 "./cmd/slim-sensor"
    (bin/"slim-sensor").chmod 0555
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slim --version")
    system "test", "-x", bin/"slim-sensor"

    (testpath/"Dockerfile").write <<~EOS
      FROM alpine
      RUN apk add --no-cache curl
    EOS

    output = shell_output("#{bin}/slim lint #{testpath}/Dockerfile")
    assert_match "Missing .dockerignore", output
    assert_match "Stage from latest tag", output
  end
end