class TsnetServe < Formula
  desc "Expose HTTP applications to a Tailscale Tailnet network"
  homepage "https:github.comshaynetsnet-serve"
  url "https:github.comshaynetsnet-servearchiverefstagsv1.2.2.tar.gz"
  sha256 "8919abe9e4d7a54539f06369c4155df57bbf7427a6007c9d4e13a908847c7308"
  license "MIT"
  head "https:github.comshaynetsnet-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "331db5b5052dbd753feece4c2b53f26bc60bbd5043366272f373847a3bff3c90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1174c09fd0bff9359d086b494d1080ab68b3262e4ab3ec06d3cd3cfab68961b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b83bec3f46ea89ec189f4cbb236eff876e77ef2e3c38766790b3a188c02731a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cf5f5587606b7eccf13cc6ebf99f760968fb95c44e205921d576bffa6fea477"
    sha256 cellar: :any_skip_relocation, ventura:       "39b8503b95a78e17f6c1a9e2add4519380ad11a556f6cc8fc92998ea876b25df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61082ea4b3cf7a31efc98274928fd075e04aa6bf8b3373ce007edbb6b964f86c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tsnet-serve -version")

    hostname = "test"
    backend = "http:localhost:8080"

    logfile = testpath"tsnet-serve.log"
    pid = spawn bin"tsnet-serve", "-hostname", hostname, "-backend", backend,
                out: logfile.to_s, err: logfile.to_s

    sleep 1

    output = logfile.read
    assert_match "starting tsnet-server (#{version})", output
    assert_match "proxying traffic to #{backend}", output
    assert_match "tsnet starting with hostname \"#{hostname}\"", output
    assert_match "LocalBackend state is NeedsLogin", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end