class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://ghfast.top/https://github.com/schollz/croc/archive/refs/tags/v10.6.0.tar.gz"
  sha256 "d9ee32d93e8353fd4330d71ee2683f08e22f4a58b2f3f5a73c1c9d622ffd4598"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efb268ba2758c5b80dbbc64ba6da00252471b10551ac213a771055afe457d970"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efb268ba2758c5b80dbbc64ba6da00252471b10551ac213a771055afe457d970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efb268ba2758c5b80dbbc64ba6da00252471b10551ac213a771055afe457d970"
    sha256 cellar: :any_skip_relocation, sonoma:        "658285baf957f75bfe4bd817ef578cebdf5626b9e6cf56417742152f40d8e499"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a54ae290c00319020d35129be7871748d0e686de8ea2aeb20eef087db4ca8e27"
    sha256 cellar: :any,                 x86_64_linux:  "5143dcd64c192779f5a968eb518f62f3a80b311b7f2afbf13dfacdecf397fe68"
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