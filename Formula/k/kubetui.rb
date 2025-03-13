class Kubetui < Formula
  desc "TUI tool for monitoring and exploration of Kubernetes resources"
  homepage "https:github.comsarub0b0kubetui"
  url "https:github.comsarub0b0kubetuiarchiverefstagsv1.6.2.tar.gz"
  sha256 "cd641e4f4c0d9cceb7a35f47018be67f2e4a6167517d92fe66e023781032d712"
  license "MIT"
  head "https:github.comsarub0b0kubetui.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef57ff4ec6220629c1b782dd037ac7ac71d7dc752a8c9efd74fb0b28958e1cc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61b2a25fe662a2224eaef38184263795e8797bd6188de7d8d190cc3c046ea763"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "400f90ff7dca1f3fc721dfa59420ec7fd83a9a1432b337c8e679ac50a9c0a1ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ea9248be3033a296a8506a99c8cbb4dcedc02df9febe402e81136cca9f25667"
    sha256 cellar: :any_skip_relocation, ventura:       "522173b09d0a1c172918b86ef8bb79d9b83450cf08e0deee6d192964c62fc6cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80bd750d17f16df9b658db9e6a5e9c28aa2813d7dab9d409233e53cbca12f4b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kubetui --version")

    # Use pty because it fails with this error in Linux CI:
    #   failed to enable raw mode: Os { code: 6, kind: Uncategorized, message: "No such device or address" }
    r, _w, pid = PTY.spawn("#{bin}kubetui --kubeconfig not_exist")

    output = ""
    begin
      r.each_line { |line| output += line }
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_match "failed to read kubeconfig", output
    assert_equal 1, $CHILD_STATUS.exitstatus
  end
end