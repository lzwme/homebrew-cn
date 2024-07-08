class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv10.0.10.tar.gz"
  sha256 "0c36b63ce4c60d9cfc0d338329911e7f358d11a2a9463e2bf5a8972d9a9f4b36"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7702cbf68d35204b7253ff6702c27675d9632adb65876f824db0cddf2d0a8f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ddbe00a297561f62a1d03d54bcd5c5aa06e1962540c19bc7a6228386d2bf570"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6ecae0c2fdf09d6d24c3e1ffecfbdbc0230ec5b12bf288df2dbb9579333991e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e522085ad6028a327a74eecfaf17f1b113b406aa259d33e4bd0ee38ec7fc090d"
    sha256 cellar: :any_skip_relocation, ventura:        "9a59966f521b1db9cec574e0cfbde3aa80805ddb5dbcd431b79a030a41ea4182"
    sha256 cellar: :any_skip_relocation, monterey:       "dd6445cced89dbcfe45b1b49a653ce07afd912bdd14c674cee1ff77b8b08a37a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae3aa73f8c214f192a814cea05523bda280d7d41da4771d5132ac7930517359"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https:github.comschollzcrocpull701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    port=free_port

    fork do
      exec bin"croc", "relay", "--ports=#{port}"
    end
    sleep 3

    fork do
      exec bin"croc", "--relay=localhost:#{port}", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 3

    assert_match shell_output("#{bin}croc --relay=localhost:#{port} --overwrite --yes homebrew-test").chomp, "mytext"
  end
end