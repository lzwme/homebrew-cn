class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://ghfast.top/https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.57.0.tar.gz"
  sha256 "39f00f21c7a4fd50ecba6c2cd1198ccefc6fc7bd556d9d6271d78a5c98a0a316"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa5c6c5a93d15939ad891d1704ae0234512af40ecc2384dc9e1c92849a7b4fad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e75c1b0c0ef3e6546e2ef46c20d9b3ba9327e4b43c343fe5b4946fd11b27a7e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00158ee3e89d654f669363046828e9b67ff667de27eda034531ad22668b8a063"
    sha256 cellar: :any_skip_relocation, sonoma:        "866505f0aab00d6f977c293d17981745dd4e492641f3c150742458b218895386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1a1bc356c505dfa281321df83812fdd474b51c56a102e5abc3ae4b54fb403ad"
    sha256 cellar: :any,                 x86_64_linux:  "a49ff47ec1004a767790a50cb2db1df3285026c4e2ced6a3dca385ed98dff28a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end