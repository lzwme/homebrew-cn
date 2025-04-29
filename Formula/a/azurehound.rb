class Azurehound < Formula
  desc "Azure Data Exporter for BloodHound"
  homepage "https:github.comSpecterOpsAzureHound"
  url "https:github.comSpecterOpsAzureHoundarchiverefstagsv2.4.0.tar.gz"
  sha256 "42653e29a604bab03388f8dae03e014891069b7fb5c933e549878a42ae24c5ff"
  license "GPL-3.0-or-later"
  head "https:github.comSpecterOpsAzureHound.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f80021823a8d6af177993e2c1a69de36a2409abe9a96c3eeba1cb7bad9277b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91f80021823a8d6af177993e2c1a69de36a2409abe9a96c3eeba1cb7bad9277b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91f80021823a8d6af177993e2c1a69de36a2409abe9a96c3eeba1cb7bad9277b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6857a38cfba768b02e1f6a7eda15412a991d77e1d06eb0bb0b94824018e5dbc7"
    sha256 cellar: :any_skip_relocation, ventura:       "6857a38cfba768b02e1f6a7eda15412a991d77e1d06eb0bb0b94824018e5dbc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62a4b33caf7f64dd7d574cb125322f8e3e97344ba9a049930fbc986025ed378d"
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