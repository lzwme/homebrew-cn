class BigqueryEmulator < Formula
  desc "Emulate a GCP BigQuery server on your local machine"
  homepage "https:github.comgoccybigquery-emulator"
  url "https:github.comgoccybigquery-emulatorarchiverefstagsv0.6.3.tar.gz"
  sha256 "58caf41996a6636df16a88adc3cb8e605ce31585d1a1f72dd04f0efd904c3154"
  license "MIT"
  head "https:github.comgoccybigquery-emulator.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc00e9a2b4074c765e9d6a62edf564f21a16a0bc78d2100613edbf21a1375fe3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0d252fb73e4ec598e38bd888ed180b6deafd2288d1ac032060cea288b5e60b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47aa3a728d1e77d8f84799f6f2abdaa6ae95a318aaac86b32d7dfe0a3e0204e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "61ed38002b3b327e951dd4339849c3a54de3757091d7f2acc362aa153139457d"
    sha256 cellar: :any_skip_relocation, ventura:        "29c7be8cc23ceb5f6feb74e4e71f97c12d36d18b99af690669e2e5967dd23c91"
    sha256 cellar: :any_skip_relocation, monterey:       "7a635db9f57d235fa1c2c7bc9cdc2359fd5c93a35314aeadead9a563cab90c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7efb8102242a476905cdd9beee9487f783374e86d323e2f362250eb77b7eef75"
  end

  depends_on "go" => :build

  uses_from_macos "llvm" => :build
  uses_from_macos "netcat" => :test

  fails_with :gcc

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = "-s -w -X main.version=#{version} -X main.revision=Homebrew"
    system "go", "build", *std_go_args(ldflags:), ".cmdbigquery-emulator"
  end

  test do
    port = free_port

    fork do
      exec bin"bigquery-emulator", "--project=test", "--port=#{port}"
    end

    sleep 5
    system "nc", "-z", "localhost", port.to_s

    assert_match "version: #{version} (Homebrew)", shell_output("#{bin}bigquery-emulator --version")
  end
end