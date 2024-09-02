class Viddy < Formula
  desc "Modern watch command"
  homepage "https:github.comsachaosviddy"
  url "https:github.comsachaosviddyarchiverefstagsv1.1.0.tar.gz"
  sha256 "7e74278a77d61c75b2ed96e717b8f6c4cf706d40f1cb08b8c82a64ff3eb04c37"
  license "MIT"
  head "https:github.comsachaosviddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a863645b4f7570dae9d22e7ca3dcb0607bf439153fa7c4733286313ed5b22444"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "782e10d7fa62643a733e0ba6267bf8690a0fc0a48628d19a6087d3615de66bfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f6a55d6c7a68156ab5429d508088e16062ab2e26d4772c792cff9cf86d7b301"
    sha256 cellar: :any_skip_relocation, sonoma:         "312052b9d005477284f67dd1dcb00985e5894bb5aba761728ead28dba4886ae4"
    sha256 cellar: :any_skip_relocation, ventura:        "c79ee39940878bfde906688c6b8fe6bbebb1eed8f5f7db901036e49c987e07bf"
    sha256 cellar: :any_skip_relocation, monterey:       "9a1ca400b15c4368972d4810f9754dfb1ec720d0c0308ececd97b3f90e8ffdfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39fa11abcc5ed2826dc85eb00d8364311f708306e1e786f8b39529fd151af031"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Inputoutput error @ io_fread - devpts0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = fork do
        system bin"viddy", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}viddy --version")
  end
end