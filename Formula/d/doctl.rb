class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://ghfast.top/https://github.com/digitalocean/doctl/archive/refs/tags/v1.157.0.tar.gz"
  sha256 "f074238056eaf398968cc2238f2a4f869f2ee6268c4d48140109cc118a73263d"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3b4551f38056836e27a9f1f1cf46c57f1c8347e0e90eecfeae898a6ec47bdc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3b4551f38056836e27a9f1f1cf46c57f1c8347e0e90eecfeae898a6ec47bdc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3b4551f38056836e27a9f1f1cf46c57f1c8347e0e90eecfeae898a6ec47bdc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b6c9adef768cbcaea093167ca040dd6bfa5c35ecbaa13198e5b65aed3170fc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdc1977d8c9f1053e3a584b4a0cb9be4d953aa95f960343d9d795a2850453f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d883de4f6c3fce5e29ac9b08f71ad343fea2d4cb9d423bc3ac90642042bb1229"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end