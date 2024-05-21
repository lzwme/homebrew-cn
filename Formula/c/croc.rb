class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv9.6.17.tar.gz"
  sha256 "d7b61c6cdb5c0d988d1bd71d0d6d97152c32e1019e5e9ce940fdeb3f06c84829"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ce6a43772a70f9cca980d16653607d3f1c23b4646dfc423f4e8d186977fa173"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c3672b8f07e5d42c08a115d5e56510d4f527647a19ed28a425e1cbf88b065cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fb1c48c0ce4f78b916f7ee31aa60fc354a63957f7b95f2fa450a47b73dda305"
    sha256 cellar: :any_skip_relocation, sonoma:         "74f424469fbcc54b306acb9fe4eda2a6bd1b1ef057c5a94dd7deb20e71f35877"
    sha256 cellar: :any_skip_relocation, ventura:        "082b56701495af58718c1e7055d661b59eafc7a8e1bd6c48863082b40c626b1e"
    sha256 cellar: :any_skip_relocation, monterey:       "2e42fa5d69e28b3d8877e784c55e244c426986190ce20bd6810f06ab9d0e36ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5bc3c19771e99b107d223fb704b218dd709206730420a0796325afeaab25c6a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https:github.comschollzcrocpull701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test" if OS.linux?

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