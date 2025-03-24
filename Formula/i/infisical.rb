class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https:infisical.comdocsclioverview"
  url "https:github.comInfisicalinfisicalarchiverefstagsinfisical-cliv0.36.20.tar.gz"
  sha256 "bcec63580ad60523a3d780f03eb80111819928adf7df83644f11c66d053e6bd8"
  license "MIT"
  head "https:github.comInfisicalinfisical.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^infisical-cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43ee1770d12b1ee1c7fa18f48a539e45334fb42d26bce4ed05e9cbb1defabe88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43ee1770d12b1ee1c7fa18f48a539e45334fb42d26bce4ed05e9cbb1defabe88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43ee1770d12b1ee1c7fa18f48a539e45334fb42d26bce4ed05e9cbb1defabe88"
    sha256 cellar: :any_skip_relocation, sonoma:        "6536bdca1b1dfef34dbc3772ab296b863767bf0725e2e4db41b4799ef3759870"
    sha256 cellar: :any_skip_relocation, ventura:       "6536bdca1b1dfef34dbc3772ab296b863767bf0725e2e4db41b4799ef3759870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d342d286b899040db11a0054c64ffeb299fdda3b60bffe9d0558c9a9d05c931"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.comInfisicalinfisical-mergepackagesutil.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}infisical --version")

    output = shell_output("#{bin}infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end