class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv10.0.9.tar.gz"
  sha256 "5f17aa4d62d50034fd8dc56e92e98adb414977da382c60be1973f7e3df3a18f3"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25b0514170d3c8513b97d06474450b5bfb4a5004e6875926f133adadb3dae423"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4eef727c6b56a09420d79fb7101d11e54ba255db46aa0a4c617f79ce5386bd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "406a726e00d5ba32bf91dca87fbd8c898679132277c988dfd5abd9f7d5797589"
    sha256 cellar: :any_skip_relocation, sonoma:         "27e2517b780f04d3ad10098dc913ea03821fe89fda681eb137ffa9ce74383e61"
    sha256 cellar: :any_skip_relocation, ventura:        "37c0c2c13858c6c7f77960453887d483e3b089e90892b473bb27b432471c8aaa"
    sha256 cellar: :any_skip_relocation, monterey:       "d590e58b492e6eb82d2d15da2a28ea1708e7235d65895fad21bbaadab7dd846d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c624087405dd81ed3f1c815063201f7d92570af00b7ab26ee43242387b334aaa"
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