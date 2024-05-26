class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https:github.comschollzcroc"
  url "https:github.comschollzcrocarchiverefstagsv10.04.tar.gz"
  sha256 "c9bbfcd2503c8d5c33ec91b0a628b116be71ac4114ad17b6afa3aed99424caf5"
  license "MIT"
  head "https:github.comschollzcroc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a5b7727ba65945f031aafb82104fcf18b7c65ec6a94f294de0f822a12dcd7e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c781a054a1389e636ea799ff50ffd4ebd882f3d8af2d3b03d7c92026048ff868"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ddcac0d12b5e674979dde035bcb583244c5229288eb9f312fe428c8da92aae2"
    sha256 cellar: :any_skip_relocation, sonoma:         "94c33be069af802300f9435c13436a4161dc441324a28a26ea2be0024244768c"
    sha256 cellar: :any_skip_relocation, ventura:        "479c6a1de8bbc3205ab467c99b133dee1a30dd90bc45088ba66c0160ddf312f2"
    sha256 cellar: :any_skip_relocation, monterey:       "d1f5466607237976735e780978e22e511690be374d9495ae415da411c1e14237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffd37e0589c5351a654d10e0679d1fd6948cdd6ca02ad789e143bc12e7593cae"
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