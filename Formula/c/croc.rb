class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv10.0.12.tar.gz"
  sha256 "849670f3525a316c44787119e1f86365f7c81d66d8b52877ac5b314e226a1eb7"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1b3f05689c54e604f513ec941ea57a7f8de066a48f7a91b868aa4784c341458a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b3f05689c54e604f513ec941ea57a7f8de066a48f7a91b868aa4784c341458a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b3f05689c54e604f513ec941ea57a7f8de066a48f7a91b868aa4784c341458a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b01c0dedc8dd80edc6c55364b4346745e95291703ab57fadf87b995e7a9de07f"
    sha256 cellar: :any_skip_relocation, ventura:        "b01c0dedc8dd80edc6c55364b4346745e95291703ab57fadf87b995e7a9de07f"
    sha256 cellar: :any_skip_relocation, monterey:       "b01c0dedc8dd80edc6c55364b4346745e95291703ab57fadf87b995e7a9de07f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0928ed02638b6f6c55638bfbb626c531be6788c7b58f48f1480c1ad04d3107f9"
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