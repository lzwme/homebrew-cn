class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v10.7.0.tar.gz"
  sha256 "044899f40b8963264ff166da575831123a2dd94759060cc15c431f540a04687f"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8292ec26a804db94fe47404c40844bf91bb0b3d9585156216d3e54a3830b44a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8292ec26a804db94fe47404c40844bf91bb0b3d9585156216d3e54a3830b44a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8292ec26a804db94fe47404c40844bf91bb0b3d9585156216d3e54a3830b44a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "42b0092fdde21a498f79dc0f8dd87279bc3a49cb6827273c01e0431f7d4cc91c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae73607c169755eaaccc0aee5e9d243054c02146337d51aa2481176ff04f0408"
    sha256 cellar: :any,                 x86_64_linux:  "5494098397d90957e284a30cdaccf44c13e146cc6c46d031cc66794e4176f75d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    ports = [free_port, free_port]

    require "pty"
    pid = PTY.spawn(bin/"croc", "relay", "--ports", ports.join(",")).last
    sleep 3

    pid_send = PTY.spawn(bin/"croc", "--relay=localhost:#{ports.first}", "send",
                                     "--no-local", "--text=mytext", "--transfers=1").last
    sleep 3

    output = shell_output("#{bin}/croc --relay localhost:#{ports.first} --overwrite --yes")
    assert_match "mytext", output
  ensure
    Process.kill("TERM", pid_send)
    Process.kill("TERM", pid)
    Process.wait(pid_send)
    Process.wait(pid)
  end
end