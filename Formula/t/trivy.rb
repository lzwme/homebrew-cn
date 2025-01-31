class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.59.0.tar.gz"
  sha256 "0fa615a6ed9729abdea646d025bdcf286932decd31ed0094011ede79be78cc43"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee1488acb7b9fe7457f238f11cbca3b8174e44f4bcec689e27654e3d934ef4e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "213553baba40a2d2bd7b6a058caa59525286a836afc06654385ba7cbf1f1c970"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96f46e3013c7c71397c9515853da19db8e219d9cae83f715368effd7e6639bc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a87f997fb160d95bcc14a5b219c09643480941ca7b36a40aea8e33244b7b6d9e"
    sha256 cellar: :any_skip_relocation, ventura:       "3579f8a888aee3774d092b677bb593d13baf3fc0996597f8fae613fa35571bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b0b59d2c95f021d3865db3123f2d2cb7ade655111baf0e35cabd40eda13b7a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comaquasecuritytrivypkgversionapp.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdtrivy"
    (pkgshare"templates").install Dir["contrib*.tpl"]

    generate_completions_from_executable(bin"trivy", "completion")
  end

  test do
    output = shell_output("#{bin}trivy image alpine:3.10")
    assert_match(\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\), output)

    assert_match version.to_s, shell_output("#{bin}trivy --version")
  end
end