class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghfast.top/https://github.com/turbot/steampipe/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "59fa1f050feed5228f9e4b70098820bc0581f9e030e72a7d5798663b7ff95c0f"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce103fd5bdc060eb7c55bda59218c8de3053dd7db1d6b8d2a0c02da99ec8492e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21f0522d5048e642d0af360d2c7f150135029bb0d7b574c8ced23b3558ceb5d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "207fd6dd829c0739983384d6bddba2cd4ec3a9926fc26950d68d7bc59a9353b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c18783d603eaf06564d17c87c8270dee9600edbfdb43cc21c6675b9f09d75c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e859762beda361f72c763a43599ac05cc96b2534550c3dd9f204ac2f3551754a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c922c3d3b8714c7b894bb003198a42127e0f4bcbccd6963547e87921308e7853"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match "Steampipe v#{version}", shell_output("#{bin}/steampipe --version")
  end
end