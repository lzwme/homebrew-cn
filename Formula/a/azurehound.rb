class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https:github.comSpecterOpsAzureHound"
  url "https:github.comSpecterOpsAzureHoundarchiverefstagsv2.2.1.tar.gz"
  sha256 "0e3c4968491a059e321e062448e58fc1c367c3189eac6d793df130cdf1b516c5"
  license "GPL-3.0-or-later"
  head "https:github.comSpecterOpsAzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "408035d9189ac52a7fe735555433d50a63e889fd0956043aead2613cc77062d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "408035d9189ac52a7fe735555433d50a63e889fd0956043aead2613cc77062d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "408035d9189ac52a7fe735555433d50a63e889fd0956043aead2613cc77062d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e4244e6edfc896cf06d696a6ba393c62a3fa0637147990aff78549c024d8c0b"
    sha256 cellar: :any_skip_relocation, ventura:       "8e4244e6edfc896cf06d696a6ba393c62a3fa0637147990aff78549c024d8c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b3a7f62a9fc4f7564eb8241848a6b91821f73811e51576261c3ec5d8ba552a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.combloodhoundadazurehoundv2constants.Version=#{version}")

    generate_completions_from_executable(bin"azurehound", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}azurehound --version")

    assert_match "No configuration file", shell_output("#{bin}azurehound list 2>&1", 1)
  end
end