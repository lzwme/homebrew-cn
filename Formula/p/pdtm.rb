class Pdtm < Formula
  desc "ProjectDiscovery's Open Source Tool Manager"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/pdtm/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "ff21f12711f04df6cbe850fd2501029eca880192a8426e7a620de46009d001e9"
  license "MIT"
  head "https://github.com/projectdiscovery/pdtm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "815821987e4e986838f7a0b266aaba4813d637ac2a056b8d025e288c0e549146"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17f60b2a08ac4a2908946980ac08b2b9acb13ba97f60cedf76051f133e870ed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a2944d3beb7ae4d02627e29a51a115580e06b7f8240c4481d33c99e5f2f9cab"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f6a74ee9db471311d47b9784cf8a4dc302b9f179cc7a55d01dbca54726ffb08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b4980f2e58c23d30de4375f3722b5b7ae8ef6290e61cc5574cefb640af928c2"
    sha256 cellar: :any,                 x86_64_linux:  "7077ce9b1b3a170c50edcb5d72f82a7225d659138897e8e2170bdd405b4d9382"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/pdtm"
  end

  test do
    # TODO: recover the version test
    # assert_match version.to_s, shell_output("#{bin}/pdtm -version 2>&1")
    assert_match "#{testpath}/.pdtm/go/bin", shell_output("#{bin}/pdtm -show-path")
  end
end