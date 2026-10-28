class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://ghfast.top/https://github.com/jmpsec/osctrl/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "81e8ae96525845d56ac98c4a1c3764f6bb59993f50d0d6011ba1d5979173c26c"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "af477415d618ed1662f9e52bbcb337ab660c92ba062bd24d014a831c610aa91f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3265412c92f68861f40e2fd4f1563951f08482a97208868b7cad31e7e6cae9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3889d04a8b0c7a559bcddb7a79ccf6f874445a5904d16ec6de9044453b1fd62a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "98e9fabf0fe6885a622c62540406c51dd6bad5f915aebdf67c6ac5a68c22d840"
    sha256 cellar: :any,                 x86_64_linux:      "17d9a1fdea260e602625933d55bdf21579c7f425bc0e140e1e4883671aaac351"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end