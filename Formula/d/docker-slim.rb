class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https:slimtoolkit.org"
  url "https:github.comslimtoolkitslimarchiverefstags1.40.9.tar.gz"
  sha256 "568103eac3c20be02c3dfb8d26723f9cf284f6a03fbbae52fe775765a7886c96"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5aa10841c5a89a3e85b1f491a89e12e558fcbe05bf9f4a99d07bc4015c100820"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a006476cb56d430906f49442ad229099e02dccba26fc0d9643ceaf981cf592b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95a44df6e057eb093dff99b262891873a49f4bc8292989c2e0ca4ed9c2e451f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "094d55fdd922f713e9f6b3436bd142bfaabfb9c7fe6d6d7a84e1e0846d21295f"
    sha256 cellar: :any_skip_relocation, ventura:        "9ab93179894b3b6926acf81ebec46963b6edfcf21bab58e5c880694b3cadc001"
    sha256 cellar: :any_skip_relocation, monterey:       "5abca7da0685967b9904e13ccd327b6d855c1d725d74b116564b2f407cda4d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2660b945e66b49c8f38feb0d3957eb279bc9adc7ec865b931d28537a89a5b6f"
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