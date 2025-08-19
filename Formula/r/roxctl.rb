class Roxctl < Formula
  desc "CLI for Stackrox"
  homepage "https://www.stackrox.io/"
  url "https://ghfast.top/https://github.com/stackrox/stackrox/archive/refs/tags/4.8.2.tar.gz"
  sha256 "5f92b652deefc9ba7269de1021df8919340a7ac02350d4bdea6b32ef056bc28c"
  license "Apache-2.0"
  head "https://github.com/stackrox/stackrox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29bee9d07dd851f675d2b9fd335c3b43a975fb9ad54d7beaab07c6278efbb1d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e758a5be78cbd5dbd5c45620ddcf300188dae9c94ea3b1218b0411c7502c5c55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9b0c229439a67696db98e18c972a0b4aa4860c942dba1a9fb9c6f7a2adca497"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9cb1acadbbeb11796a7d41eec9fa6885a4b69481b3756965befaa3de9c3c401"
    sha256 cellar: :any_skip_relocation, ventura:       "48a6270c4957be156e85db9a0a57e9305ae9e940526bfa064a895c03bff8e318"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66d24c3eb299ba8aa5fec21973b1822b7df98640f938bd54955255dcc4eb23d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6e995d80203a77bf16ec52c1b15afae060bedde836304ed4c328830b1e39ecf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./roxctl"

    generate_completions_from_executable(bin/"roxctl", "completion")
  end

  test do
    output = shell_output("#{bin}/roxctl central whoami 2<&1", 1)
    assert_match <<~EOS, output
      ERROR:	obtaining auth information for localhost:8443: \
      retrieving token: no credentials found for localhost:8443, please run \
      "roxctl central login" to obtain credentials
    EOS
  end
end