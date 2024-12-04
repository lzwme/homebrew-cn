class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https:aquasecurity.github.iotrivy"
  url "https:github.comaquasecuritytrivyarchiverefstagsv0.58.0.tar.gz"
  sha256 "c0637d98cb48a6de2ef474288e3c1ad4eabd2f8e55a3b4910ea830819eb1f98e"
  license "Apache-2.0"
  head "https:github.comaquasecuritytrivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dae9e7721c4f705a097a9bb9708d7f319cdda924b5887f2c520c909823c8104f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "545d23e8a643220eb1b99c3d011fc1b19098b2dd6aa89ed50be3d68f0be57fae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2130ab5a33635158f9813c4cc03d3e29037ed58beee967ecd307eb7cf36e986f"
    sha256 cellar: :any_skip_relocation, sonoma:        "094f24e162fb735aab06e1191b5ed2145d8f8ede9d22de095ee401759b7cb2de"
    sha256 cellar: :any_skip_relocation, ventura:       "3f589ab875a971068881b655964b25de0d94210048b6a223bff6f29c5e37b427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d64d18b12fc1b299dd66607094132774e7aaceeac9edfe9c8e813fff11aa38d"
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