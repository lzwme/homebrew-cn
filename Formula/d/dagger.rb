class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "ce4fc922b15ef3ec678af23097922c86570b5fe9d4de555c6c529fc66ee18642"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf5fed742663faa2724f1564194d556c313dcca93f984af1b495c383af71fc94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf5fed742663faa2724f1564194d556c313dcca93f984af1b495c383af71fc94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf5fed742663faa2724f1564194d556c313dcca93f984af1b495c383af71fc94"
    sha256 cellar: :any_skip_relocation, sonoma:        "38de9e104b34d116de1c46ed1c3340f3543f98d7b759d6f471c687262f2ce172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "249bfab27037c1b01a637dacd4d7a1014474593074279f966b131ace4949934b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32a3a49ce1b69033d19bdbc8615e3135f8d74e108ac8fb570c5e63e7774b0eba"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "failed to connect to the docker API", output
  end
end