class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://ghfast.top/https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.22.0.tar.gz"
  sha256 "d072ed68adc6d11188f3062e280a170a3bd099a146cd1815261ec6923e9886d7"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a6c20ea79dd0fda3495074871c3cf4875090c0c84b79df7863900df31dc29ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a6c20ea79dd0fda3495074871c3cf4875090c0c84b79df7863900df31dc29ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a6c20ea79dd0fda3495074871c3cf4875090c0c84b79df7863900df31dc29ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ccb90db2de10d694976b9fa8fdc3e1a01ac4ecf9b2613967da50903a4c2c60c"
    sha256 cellar: :any_skip_relocation, ventura:       "6ccb90db2de10d694976b9fa8fdc3e1a01ac4ecf9b2613967da50903a4c2c60c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30588507d1516cccdd33f1d4d2c36218ee8a906aa4cf06c75f68d8b855af4e5e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    YAML
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end