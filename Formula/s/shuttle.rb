class Shuttle < Formula
  desc "CLI for handling shared build and deploy tools between many projects"
  homepage "https:github.comlunarwayshuttle"
  url "https:github.comlunarwayshuttlearchiverefstagsv0.24.3.tar.gz"
  sha256 "4a8b93f01e9e21e543c393f59214145850895c89c2c6924a7faac6f8f12292cb"
  license "Apache-2.0"
  head "https:github.comlunarwayshuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "414eba11f78301d309539025b2a9bee382861c85a6ffb60a8d6088eccf49f309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "414eba11f78301d309539025b2a9bee382861c85a6ffb60a8d6088eccf49f309"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "414eba11f78301d309539025b2a9bee382861c85a6ffb60a8d6088eccf49f309"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc4f871490cdf6db9bf94893d38fec42bcf43c112551bd5be81a0a0881208467"
    sha256 cellar: :any_skip_relocation, ventura:       "bc4f871490cdf6db9bf94893d38fec42bcf43c112551bd5be81a0a0881208467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c99e855c6690a5fbe1c25e42989b914ecd974f185c6229d83796dae55ad870f7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comlunarwayshuttlecmd.version=#{version}
      -X github.comlunarwayshuttlecmd.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"shuttle", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}shuttle version")

    (testpath"shuttle.yaml").write <<~YAML
      plan: 'https:github.comlunarwayshuttle-example-go-plan.git'
      vars:
        docker:
          baseImage: golang
          baseTag: stretch
          destImage: repo-project
          destTag: latest
    YAML

    assert_match "Plan:", shell_output("#{bin}shuttle config")

    output = shell_output("#{bin}shuttle telemetry upload 2>&1", 1)
    assert_match "SHUTTLE_REMOTE_TRACING_URL or upload-url is not set", output
  end
end