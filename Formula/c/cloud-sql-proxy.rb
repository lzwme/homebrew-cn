class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https:github.comGoogleCloudPlatformcloud-sql-proxy"
  url "https:github.comGoogleCloudPlatformcloud-sql-proxyarchiverefstagsv2.11.3.tar.gz"
  sha256 "4701dbce6e81ceb43a7e78e721549400141569ff0876e9a306d6ff0c2a86bbed"
  license "Apache-2.0"
  head "https:github.comGoogleCloudPlatformcloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d59e4c1fa18f4c63b9ed59763e973ab6747a8e220eb154c36b75c1b10e25b52f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8484ec54be2f73d37e2976fc2783097a62bddf41beaa50ec7a45c7a3e3d572f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "094912dca946abc49f0142a33e3389a79231c88a746d9d5f0d0f3ba6d8fb9af2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f81f8209b1c4ca4f7a1b7689d4542f3649c9a40b8905c033075f2b05660661f"
    sha256 cellar: :any_skip_relocation, ventura:        "72faad991b61ad1d05908c2ca550c7e9d802309125b25a55e3b14b8fe8d4ff9d"
    sha256 cellar: :any_skip_relocation, monterey:       "dc392a58bfef0656805d5411dcde1fe013f74813e2cbaa920fb0f55de4b17c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b11dc0fdd644011dfd20523343e92050a888f14e899f8d59cde439676d6654"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}cloud-sql-proxy test 2>&1", 1)
  end
end