class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https:temporal.io"
  url "https:github.comtemporaliocliarchiverefstagsv1.1.2.tar.gz"
  sha256 "24e22de1d36f94df466439b1dd53aff5d4e684e1f9f1da02468096198df493f3"
  license "MIT"
  head "https:github.comtemporaliocli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e8c8c6de97ade1b780f71f8924bbf5a04658420fd29129fd7cdece3b9f97a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e8c8c6de97ade1b780f71f8924bbf5a04658420fd29129fd7cdece3b9f97a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e8c8c6de97ade1b780f71f8924bbf5a04658420fd29129fd7cdece3b9f97a19"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3aa0d666ad38eccca5e8d50764682f43d0d43168e703f1719c205a542e29d17"
    sha256 cellar: :any_skip_relocation, ventura:       "e3aa0d666ad38eccca5e8d50764682f43d0d43168e703f1719c205a542e29d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "051d2781c004699c386ed25429d4754f5dbfae0a2f243cf1d551080753855d0d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comtemporalioclitemporalcli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdtemporal"
    generate_completions_from_executable bin"temporal", "completion"
  end

  service do
    run [opt_bin"temporal", "server", "start-dev"]
    keep_alive true
    error_log_path var"logtemporal.log"
    log_path var"logtemporal.log"
    working_dir var
  end

  test do
    run_output = shell_output("#{bin}temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end