class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https://github.com/SpecterOps/AzureHound"
  url "https://ghfast.top/https://github.com/SpecterOps/AzureHound/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "da22d48396cf07732b7b8b2a0418de3ae20eb99ec67a786bd14e5cd144d6ff70"
  license "GPL-3.0-or-later"
  head "https://github.com/SpecterOps/AzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab5ca24f340c4ed920b52738a63e4533e1c4ba6e0a047fb66ee7ec36a7a2454e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab5ca24f340c4ed920b52738a63e4533e1c4ba6e0a047fb66ee7ec36a7a2454e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab5ca24f340c4ed920b52738a63e4533e1c4ba6e0a047fb66ee7ec36a7a2454e"
    sha256 cellar: :any_skip_relocation, sonoma:        "95ea86b11522b9e6ff6c5f31b62e12e3f8ecbf920c061b7e1079bd87652ca4fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71fbc190ce99a167eedf08df21d57e624cf3d3bce7c7e8f5d574ceb8eb0eacfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b24741de8cc21fff8b65c4c631ca766cf3ae18774d6d8e2fbf055a0ea322e427"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bloodhoundad/azurehound/v2/constants.Version=#{version}")

    generate_completions_from_executable(bin/"azurehound", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}/azurehound list 2>&1", 1)
  end
end