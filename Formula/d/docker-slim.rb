class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https:slimtoolkit.org"
  url "https:github.comslimtoolkitslimarchiverefstags1.40.8.tar.gz"
  sha256 "c5bf341aab1b7a705c9b92f801d78755e9204842498702ff0c3c500550384469"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "677c8fcde343a97375a7372c214b68183a883d4072b6fa5792a1c8e51106af6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "573a18760ae7ff147cb4e7aac5ac51350875ae1b08aba1d614ff33c96a195e23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2612317ffadd32b1899be2dccd8873165e084ecb9207a7bd9b15ba7c4ce7c09f"
    sha256 cellar: :any_skip_relocation, sonoma:         "80fc74450f6856fcee0432e00f0542f13a094ba3bc61f742a001b11691d2df6f"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ea5051f852710c7482cc8aaff252a1b5b4c83089e9946152dcaec45ba4c5ca"
    sha256 cellar: :any_skip_relocation, monterey:       "f33b006e9e127d7801097b139deec9d70e1f5dfbeb0ee7a5c654bf07fab1d745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "789a8ae3b9102af01ba3be5c7d9d3e1668c4cac23aca25658c5cbc2bf5ca3062"
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