class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://ghfast.top/https://github.com/SpecterOps/AzureHound/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "79612cf43c602459f3b199eb1cc9c799b2450b7496948fd05240f9147e8fcfe2"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0533174698ec77990c5798974a602cb7cbeee68e4646e391c21dcf8df9e9fb43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0533174698ec77990c5798974a602cb7cbeee68e4646e391c21dcf8df9e9fb43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0533174698ec77990c5798974a602cb7cbeee68e4646e391c21dcf8df9e9fb43"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a18ec0e4e38d9eb620e84998102dda4acb2d8c2bd319b40498d2a1dd2cd6e24f"
    sha256 cellar: :any,                 x86_64_linux:      "6399c058ba0d3d2e0211dae34f731a1b9bc2764d7d526986ba8a94c565bfd72d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/SpecterOps/AzureHound/v2/constants.Version=#{version}")

    generate_completions_from_executable(bin/"azurehound", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}/azurehound list 2>&1", 1)
  end
end