class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.21.6.tar.gz"
  sha256 "b4f2c2bca4e19e9b3758939ed119292b437a43ac380afc18b52e1cd36c8ac657"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c42453f14adc241adea1619df19cc0eba6c03e2e8256487df63f6e37b13a577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c42453f14adc241adea1619df19cc0eba6c03e2e8256487df63f6e37b13a577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c42453f14adc241adea1619df19cc0eba6c03e2e8256487df63f6e37b13a577"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7d2ff03c2f0f8d7b8fde2cccc8ded55b2a6bdcbcef4f03228625cb35721490e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d263e3d66f9512644141eb17dedddfcc6af54fe6e1b33471abd8e5afc2c8b479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d53541ed3fcb754d77e94e5cd7e828d92134d736095d9dd6f3acc9ba906f6af4"
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