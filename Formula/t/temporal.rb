class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://ghfast.top/https://github.com/temporalio/cli/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "03fbd0088ae5c0193e8f3d143579546a9790b3af2bd5a00e4266126c77cbb3c7"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "113e3c7f6d8748282f3a0ad4d537a41faa7a3f6154498419c25036e55cb820ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "901cc239d92b512c79c0c4034ffcea0b41f6835560620265371fbd62a61009ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f81611b9374e37015cf07c2f58088cae8a01a608923e978b385c64a65a84016c"
    sha256 cellar: :any_skip_relocation, sonoma:        "af2ce0b418365b9f545cdf59f9e4f5948c4339e3c51e5f4823fb2457c8a58b4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b924e4ae5096b1785283144126e9eb7c331a43da55c8c08605b99d53451b91c9"
    sha256 cellar: :any,                 x86_64_linux:  "76aef1e99f896f97846ffd4663232b35222343adf98e496498f27fe1051cdc6c"
  end

  depends_on "go" => :build

  def install
    v = build.head? ? "0.0.0-HEAD+#{Utils.git_short_head}" : version.to_s
    ldflags = "-s -w -X github.com/temporalio/cli/internal/temporalcli.Version=#{v}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"

    generate_completions_from_executable(bin/"temporal", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"temporal", "server", "start-dev"]
    keep_alive true
    error_log_path var/"log/temporal.log"
    log_path var/"log/temporal.log"
    working_dir var
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end