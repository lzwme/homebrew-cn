class Azcopy < Formula
  desc "Azure Storage data transfer utility"
  homepage "https://github.com/Azure/azure-storage-azcopy"
  url "https://ghfast.top/https://github.com/Azure/azure-storage-azcopy/archive/refs/tags/v10.31.0.tar.gz"
  sha256 "21ca550d42bb06807d985a5ac003c0b479d55cf15506e948c78a419b421eb5c4"
  license "MIT"
  head "https://github.com/Azure/azure-storage-azcopy.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79ea7b96d109ea48fa9f2fab2c0389df9b01cca23c678c816295f8ccc61262a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4d6adb2d394b1272c78cecd033b5d10d3f2bff7576f57fe1adc258caf426445"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a9c9afa914f344ac436e1dfe0592234d146cd0b6550ec2e69169c574ba930a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a967704656bb73e615538665399924c87fb27e18b39b61fb3b7cf65dc096f682"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cab26d652b475da640ee7e947ec6f0b797deed722b6d60b5bfebee9e8b9f803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2723bbc080ffd2f1a651623fd8d398498cc00c7d5c34c79a53b2548f5d619f68"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"azcopy", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Existing Jobs", shell_output("#{bin}/azcopy jobs list")
    assert_match version.to_s, shell_output("#{bin}/azcopy --version")
  end
end