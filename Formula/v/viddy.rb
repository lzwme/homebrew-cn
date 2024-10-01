class Viddy < Formula
  desc "Modern watch command"
  homepage "https:github.comsachaosviddy"
  url "https:github.comsachaosviddyarchiverefstagsv1.1.5.tar.gz"
  sha256 "abc01bc4eae92f6fbf11ea220f1ef8ee88e48f80b090e09d0c5d5e4cf23d9065"
  license "MIT"
  head "https:github.comsachaosviddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43015ce049479dbf069f0bbf6aa194748dfd853cce65457c9f239d58db591cd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98dd8b7044e558011fca0bc95f3633871f6c0f67d01233184b69f3512e546e8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76104110cc4785febdb44a2dd3862ce63e257180ffe3279f8b9994360e169eae"
    sha256 cellar: :any_skip_relocation, sonoma:        "793b688972baa4cfc8ffc97574eaaca452ec103358bfa93e374b348920545946"
    sha256 cellar: :any_skip_relocation, ventura:       "0595711bf25f8a4fd4f992beafe0e945c0b8a4b2a18b0d11312f98bbd0fdf96b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "057f9ffa5ba094fc9c2e75ba4de808eabc9a6e24a9292919c28a57cd505185fc"
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