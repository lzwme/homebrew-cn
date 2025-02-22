class Ignite < Formula
  desc "Build, launch, and maintain any crypto application with Ignite CLI"
  homepage "https:docs.ignite.com"
  url "https:github.comignitecliarchiverefstagsv28.8.0.tar.gz"
  sha256 "2095015769f34287e7a64fe679783ab71d7701a63757370a4414032a36d501be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8caa499dff1bfab394528c6919b8bcabaf50d0cd0b01bed03788ed3b2b805338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "771d84c0376e43d5c445dd2c311460e9215e7c1266be98b03a39e963b64bae70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64b4f2c0f3aa6648f8f7dc805cb4cfbdfc308f840c3feff99a3dc8618605b743"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b30c3bef4ff5de6776b563f46dc63b49e8e14ab3dd5b2a2ba5c34333d2d7191"
    sha256 cellar: :any_skip_relocation, ventura:       "754c4db1c42bbbb070f982c90f572842474cc282f8fe43cd9b90484682db0c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a61203b6d611d9bb947e28bbf6d239910c44b7290c8f76cb1c1642628116cd4e"
  end

  depends_on "go"
  depends_on "node"

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w", output: bin"ignite"), ".ignitecmdignite"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    system bin"ignite", "s", "chain", "mars"
    sleep 2
    assert_path_exists testpath"marsgo.mod"
  end
end