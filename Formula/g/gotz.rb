class Gotz < Formula
  desc "Displays timezones in your terminal"
  homepage "https:github.commerschformanngotz"
  url "https:github.commerschformanngotzarchiverefstagsv0.1.13.tar.gz"
  sha256 "8bc7be0a954aedc2bdbbabb27e81d4c257443f6aa784b770294ad56e7cebdaac"
  license "MIT"
  head "https:github.commerschformanngotz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7517157f5b5c8c0611af3bcfbcef7aff207d75e13a86373dbb76736eafb435d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7517157f5b5c8c0611af3bcfbcef7aff207d75e13a86373dbb76736eafb435d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7517157f5b5c8c0611af3bcfbcef7aff207d75e13a86373dbb76736eafb435d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d000373150d1f394a6a29f1ccf647150f23d3e77ac0dbb6d22fe9ddf5664d74f"
    sha256 cellar: :any_skip_relocation, ventura:       "d000373150d1f394a6a29f1ccf647150f23d3e77ac0dbb6d22fe9ddf5664d74f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdfc38f0f1b39b310f96c6f9dc9f364b38e49e4907959aa61e5261346ec51274"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gotz -version")
    assert_match "Local", shell_output("#{bin}gotz -timezones AmericaNew_York")
  end
end