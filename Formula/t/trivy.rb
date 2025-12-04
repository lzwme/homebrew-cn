class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://trivy.dev/"
  url "https://ghfast.top/https://github.com/aquasecurity/trivy/archive/refs/tags/v0.68.1.tar.gz"
  sha256 "9dd35dd79b0452ab5cf426fac6511718473cc42f92dc6c494839e42690f8023d"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23e2c1d604c09a2d66df48f6b846c348a0428d1cdda307b8202f626a5f94c979"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22af609008cf1922c8349091ad22f6c2431d42618cb5f9cfe7743294c7573729"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7416c1b961be1da94d88a7809227150198cd258a6c102956e5b5bfcb22c90a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c4de1b5a1222c5332ae8c4e6d688b5cf1775adce9a451432804c2d84712c9a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57d1a379c568d9bca92490d03dd9c1b52d8fefe91d28981e3e326ff1144be4fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7f7768712a6c4002b462b152c94fd0f13523be3971299043e8fca2ddf115cf8"
  end

  depends_on "go" => :build

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
    (pkgshare/"templates").install Dir["contrib/*.tpl"]

    generate_completions_from_executable(bin/"trivy", "completion")
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end