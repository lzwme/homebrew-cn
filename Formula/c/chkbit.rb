class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https:github.comlaktakchkbit"
  url "https:github.comlaktakchkbitarchiverefstagsv6.3.0.tar.gz"
  sha256 "69b48926eb3bff15e8e7a1501d906e7ca84646275d47121399e7f3b10d629449"
  license "MIT"
  head "https:github.comlaktakchkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3c7e001bb849028265c2f36f23091593918931170a795a1c3c7cfd8eee360ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3c7e001bb849028265c2f36f23091593918931170a795a1c3c7cfd8eee360ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3c7e001bb849028265c2f36f23091593918931170a795a1c3c7cfd8eee360ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e5f08f13de435bcfb330835e98daae082159e13a5f9585fef78743684139f8b"
    sha256 cellar: :any_skip_relocation, ventura:       "6e5f08f13de435bcfb330835e98daae082159e13a5f9585fef78743684139f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7447e81531314e5c7353cc812268d53e3aae66265828479e31fc7adf8c0f8f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdchkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chkbit version").chomp
    system bin"chkbit", "init", "split", testpath
    assert_path_exists testpath".chkbit"
  end
end