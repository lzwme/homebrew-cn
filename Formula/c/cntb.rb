class Cntb < Formula
  desc "Contabo Command-Line Interface (CLI)"
  homepage "https:github.comcontabocntb"
  url "https:github.comcontabocntbarchiverefstagsv1.4.11.tar.gz"
  sha256 "fbed0f240a65c94cddbb7106a549e371beeb4e0b7b021fcf1a9f83e0c0455675"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed355d01429f64773c8e4ed4a7c61a5ed107d30fd4f5ace467372c34ae4ae355"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "971f4536fdec424805bf3c946576d92261bbb5a2d86c71ab171c9de3f3292472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df18101b7c9f0292a299889f4f307b52f02e66ae21689577bfe27f848fc93b03"
    sha256 cellar: :any_skip_relocation, sonoma:         "304d1acb900fc80b64e463f8d7e8938aa1a07d576a5d168807d1901eabb9dd23"
    sha256 cellar: :any_skip_relocation, ventura:        "d4c5c8549bf7f5ae09fc1b1ef4de6d46aa9cb33d5679e5cd5dfd8f37c950fa65"
    sha256 cellar: :any_skip_relocation, monterey:       "ff921cb185d6506e7b922d318c25fd7f70fa73cc24e01fc710f9e2f5edf50e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c847c91711ed1b8ab52b6c83cd43d381e2602f45daba84a90b0e721541f9790"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X contabo.comclicntbcmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"cntb", "completion")
  end

  test do
    # version command should work
    assert_match "cntb #{version}", shell_output("#{bin}cntb version")
    # authentication shouldn't work with invalid credentials
    out = shell_output("#{bin}cntb get instances --oauth2-user=invalid \
    --oauth2-password=invalid --oauth2-clientid=invalid \
    --oauth2-client-secret=invalid \
    --oauth2-tokenurl=https:example.com 2>&1", 1)
    assert_match 'level=fatal msg="Could not get access token due to an error', out
  end
end